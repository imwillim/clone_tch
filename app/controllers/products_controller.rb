# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :validate_schema

  def show
    service = GetProductService.call(params[:id])

    if service.success?
      # TODO: Use custom serializer to accept more generic case
      product = ProductSerializer.new(service.result).serializable_hash
      render json: { data: product }, status: :ok
    else
      render json: { message: service.first_error.message }, status: :not_found
    end
  end

  private

  def validate_schema
    contract = ProductContract.new
    result = contract.call(id: params[:id])
    return if result.errors.blank?

    render json: { errors: result.errors.to_h }, status: :bad_request # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods

    # TODO: raise error and catch in application_controller
  end
end
