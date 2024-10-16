# frozen_string_literal: true

class ProductsController < ApplicationController
  schema(:index) do
    required(:category_id).value(:string, :uuid_v4?)
  end

  def index
    service = GetProductsService.call(params[:category_id])

    if service.success?
      render json: { data: service.result }, status: :ok
    else
      render json: { message: service.first_error.message }, status: :unprocessable_entity
    end
  end

  schema(:show) do
    required(:id).value(:string, :uuid_v4?)
  end

  def show
    service = GetProductService.call(params[:id])

    if service.success?
      # TODO: Use custom serializer to accept more generic case
      product = service.result
      product = ProductSerializer.new(product).serializable_hash if product.is_a? Product
      render json: { data: product }, status: :ok

    else
      render json: { message: service.first_error.message }, status: :unprocessable_entity
    end
  end
end
