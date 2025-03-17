# frozen_string_literal: true

class GetProductsService < BaseService
  def initialize(safe_params)
    super()
    @category_id = safe_params[:category_id]
    @price = safe_params[:price]
  end

  def call
    validate
    return self if error?

    @result = fetch_products
  end

  private

  attr_reader :category_id

  def build_products_cte
    if Category.where(id: @category_id, parent_id: nil).present?
      Product.with(products: Product.left_outer_joins(category: :parent))
    else
      Product.with(products: Product.left_outer_joins(category: :parent)
                                    .where(category_id: @category_id)
                                    .or(Category.where(parent_id: @category_id)))
    end
  end

  def build_query
    products = build_products_cte
    products = products.left_outer_joins(:tags)
                       .joins(:category)
                       .joins(category: :parent)
    products = products.order('products.price': @price) if @price.present?

    products.select('products.id AS product_id, products.name AS product_name,
                 products.price AS product_price, products.thumbnail AS product_thumbnail,
                 categories.id AS category_id, categories.name AS category_name,
    tags.name AS tag_name, tags.color AS tag_color')
  end

  def fetch_products
    products = build_query

    group_products_by_category(products)
  end

  def group_products_by_category(products)
    products.group_by { |product| product[:category_name] }.map do |category_name, elements|
      {
        name: category_name,
        products: process_category_products(elements)
      }
    end
  end

  def process_category_products(elements)
    elements.group_by { |element| element[:product_id] }.values.map do |product_group|
      base_product = product_group.first
      tags = extract_tags(product_group)

      transform_product(base_product, tags)
    end
  end

  def extract_tags(product_group)
    product_group.filter_map do |product|
      { name: product[:tag_name], color: product[:tag_color] } if product[:tag_name]
    end
  end

  def transform_product(product, tags)
    {
      id: product[:product_id],
      name: product[:product_name],
      price: product[:product_price],
      thumbnail: product[:product_thumbnail],
      tags: tags
    }
  end

  def validate
    add_error(I18n.t('errors.models.not_found', record: :category)) if Category.where(id: @category_id).blank?
  end
end
