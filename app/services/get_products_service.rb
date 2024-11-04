# frozen_string_literal: true

class GetProductsService < BaseService
  def initialize(category_id)
    super()
    @category_id = category_id
  end

  def call
    cached_products = CacheManager.fetch_value(category_id)
    if cached_products.present?
      @result = JSON.parse(cached_products)
    else
      validate
      return self if error?

      @result = fetch_products
      CacheManager.assign_value(category_id, @result.to_json)
    end
  end

  private

  attr_reader :category_id

  def build_category_cte
    if Category.where(id: @category_id, parent_id: nil).present?
      Category.with(categories: Category.left_outer_joins(:parent))
    else
      Category.with(categories: Category.left_outer_joins(:parent)
                                        .where(parent_id: @category_id)
                                        .or(Category.where(id: @category_id)))
    end
  end

  def build_query
    category_cte = build_category_cte
    category_cte
      .joins(:products)
      .left_outer_joins(products: :tag)
      .select('categories.id AS category_id, categories.name AS category_name,
             products.id AS product_id, products.name AS product_name,
             products.price AS product_price, products.thumbnail AS product_thumbnail,
             tags.name AS tag_name, tags.color AS tag_color')
  end

  def fetch_products
    products = build_query
    @result = products.group_by { |product| product[:category_name] }.map do |category_name, elements|
      {
        name: category_name,
        products: elements.map! do |element|
          transform_product(element)
        end
      }
    end
  end

  def transform_product(product)
    {
      id: product[:product_id],
      name: product[:product_name],
      price: product[:product_price],
      thumbnail: product[:product_thumbnail],
      tag: {
        name: product[:tag_name],
        color: product[:tag_color]
      }
    }
  end

  def validate
    add_error(I18n.t('errors.models.not_found', record: :category)) if Category.where(id: @category_id).blank?
  end
end
