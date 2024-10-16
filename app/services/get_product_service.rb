# frozen_string_literal: true

class GetProductService < BaseService
  def initialize(product_id)
    super()
    @product_id = product_id
  end

  def call
    validate
    return self if error?

    RedisWrapper.redis_pool.then do |redis|
      cached_product = redis.get(@product_id)
      if cached_product.nil?
        @result = Product.includes(:sizes, :toppings, :tag).find_by(id: product_id)
        redis.set(@product_id, result.to_json)
        result
      else
        JSON.parse(cached_product)
      end
    end
  end

  private

  attr_reader :product_id

  def validate
    add_error(I18n.t('errors.models.not_found', record: :product)) if Product.where(id: product_id).blank?
  end
end
