# frozen_string_literal: true

class OrderController < ApplicationController
  schema(:create) do
    required(:user_phone).filled(:str?)
    required(:store_id).filled(:int?)
    required(:order_items).array do
      schema do
        required(:product_id).filled(:uuid_v4?)
        required(:quantity).filled(:int?).value(gt?: 0)
        optional(:price).filled(:float?)
        optional(:discount).filled(:float?)
        optional(:version).filled(:int?)
      end
    end
  end

  def create
    service = CreateOrdersService.call(safe_params)

    if service.success?
      render json: { order_id: service.result.id }, status: :created
    else
      # TODO: STATUS NOT EXACT
      render json: { errors: service.errors }, status: :bad_request
    end
  end
end
