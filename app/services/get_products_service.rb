# frozen_string_literal: true

class GetProductsService < BaseService
  def initialize(category_id)
    super()
    @category_id = category_id
  end

  def call
    validate
    return self if error?

    @result = build_query
    result
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

  def validate
    add_error(I18n.t('errors.models.not_found', record: :category)) if Category.where(id: @category_id).blank?
  end
end