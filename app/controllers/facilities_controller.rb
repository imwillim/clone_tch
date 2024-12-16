# frozen_string_literal: true

class FacilitiesController < ApplicationController
  schema(:show) do
    required(:id).value(:uuid_v4?)
  end

  def show
    facility = Facility.find(safe_params[:id])

    render json: facility, status: :ok
  end
end
