# frozen_string_literal: true

class ProductsController < ApplicationController
  schema(:show) do
    required(:id).value(:string, :uuid_v4?)
  end

  def show
    service = GetProductService.call(params[:id])

    if service.success?
      # TODO: Use custom serializer to accept more generic case
      product = ProductSerializer.new(service.result).serializable_hash
      render json: { data: product }, status: :ok
    else
      render json: { message: service.first_error.message }, status: :unprocessable_entity
    end
  end
end
