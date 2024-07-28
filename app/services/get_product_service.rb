# frozen_string_literal: true

class GetProductService < BaseService
  def initialize(product_id)
    super()
    @product_id = product_id
  end

  def call
    validate
    return self if error?

    @result = Product.includes(:sizes, :toppings, :tag).find_by(id: product_id)
    result
  end

  private

  attr_reader :product_id

  def validate
    add_error(I18n.t('errors.models.not_found', record: :product)) if Product.where(id: product_id).blank?
  end
end
