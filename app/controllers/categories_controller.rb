# frozen_string_literal: true

class CategoriesController < ApplicationController
  schema(:sizes) do
    required(:id).value(:uuid_v4?)
  end

  def sizes
    sizes = Category.joins(:products).joins(products: :sizes)
                    .where(id: safe_params[:id])
                    .select('sizes.id AS id, sizes.name AS name')
    render json: sizes, status: :ok
  end

  schema(:toppings) do
    required(:id).value(:uuid_v4?)
  end

  def toppings
    toppings = Category.joins(:products).joins(products: :toppings)
                       .where(id: safe_params[:id])
                       .select('toppings.id AS id, toppings.name AS name')
    render json: toppings, status: :ok
  end
end
