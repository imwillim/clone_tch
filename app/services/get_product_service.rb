# frozen_string_literal: true

class GetProductService < BaseService
  def initialize(product_id)
    super()
    @product_id = product_id
  end

  def call
    cached_product = CacheManager.fetch_value(product_id)

    if cached_product.present?
      @result = JSON.parse(cached_product)
    else
      validate
      return self if error?

      @result = Product.includes(:sizes, :toppings, :tags).find_by(id: product_id)
      serialized_product = ProductSerializer.new(@result).serializable_hash

      CacheManager.assign_value(product_id, serialized_product.to_json)
    end
  end

  private

  attr_reader :product_id

  def validate
    add_error(I18n.t('errors.models.not_found', record: :product)) if Product.where(id: product_id).blank?
  end
end
