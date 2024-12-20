# frozen_string_literal: true

class FacilitiesController < ApplicationController
  schema(:show) do
    required(:id).value(:uuid_v4?)
  end

  def show
    facility = Facility.find(safe_params[:id])

    render json: facility, status: :ok
  end

  schema(:create) do
    required(:store_id).value(:integer)
    required(:name).filled(:string)
    required(:icon).filled(:string)
  end

  def create
    store = Store.find(safe_params[:store_id])
    facility = store.facilities.create!(
      name: safe_params[:name],
      icon: safe_params[:icon]
    )

    render json: facility, store_id: safe_params[:store_id],
           status: :created
  end

  schema(:update) do
    required(:id).value(:uuid_v4?)
    optional(:name).value(:string)
    optional(:icon).value(:string)
  end

  def update
    facility = Facility.update!(safe_params[:id],
                                name: safe_params[:name],
                                icon: safe_params[:icon])

    render json: facility, status: :accepted
  end

  schema(:destroy) do
    required(:id).value(:uuid_v4?)
  end

  def destroy
    Facility.destroy_by(id: safe_params[:id])

    render status: :no_content
  end

  private

  def serialize(facility, store_id)
    {
      id: facility.id,
      name: facility.name,
      icon: facility.icon,
      created_at: facility.created_at,
      updated_at: facility.updated_at,
      store_id:
    }
  end
end
