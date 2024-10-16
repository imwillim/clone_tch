# frozen_string_literal: true

class GetProductService < BaseService
  def initialize(product_id)
    super()
    @product_id = product_id
  end

  def call
    validate
    return self if error?

    if fetch_cached_value.present?
      @result = JSON.parse(fetch_cached_value)
    else
      @result = Product.includes(:sizes, :toppings, :tag).find_by(id: product_id)
      assign_cached_value(@result)
    end
  end

  private

  attr_reader :product_id

  def validate
    add_error(I18n.t('errors.models.not_found', record: :product)) if Product.where(id: product_id).blank?
  end

  def fetch_cached_value
    RedisWrapper.redis_pool.then do |redis|
      redis.get(product_id)
    end
  end

  def assign_cached_value(product)
    RedisWrapper.redis_pool.then do |redis|
      redis.set(product_id, product.to_json)
    end
  end
end
