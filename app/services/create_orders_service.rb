# frozen_string_literal: true

class CreateOrdersService < BaseService
  def initialize(safe_params)
    super()
    @user_phone = safe_params[:user_phone]
    @store_id = safe_params[:store_id]
    @order_items = safe_params[:order_items]
  end

  def call
    validate
    return self if error?

    begin
      @result = Order.create!(user_id: user.id,
                              store_id: store.id,
                              order_items_attributes: @order_items)
    rescue ActiveRecordError => e
      add_error(I18n.t('errors.models.create_failed', record: :order, message: e.message))
    end
  end

  private

  def validate
    return add_error(I18n.t('errors.models.not_found', record: :user)) if user.nil?

    return add_error(I18n.t('errors.models.not_found', record: :store)) if store.nil?

    validate_products(@order_items)
  end

  def user
    @user ||= User.find_by(phone: @user_phone)
  end

  def store
    @store ||= Store.find(@store_id)
  end

  def validate_products(order_items)
    request_product_ids = order_items.pluck(:product_id).to_set
    product_ids = Product.select(:id).where(id: request_product_ids).pluck(:id).to_set

    not_found_ids = request_product_ids - product_ids
    not_found_ids.map do |id|
      return add_error(I18n.t('errors.models.not_found', record: :product, id: id)) if not_found_ids.include?(id)
    end
  end
end
