# frozen_string_literal: true

class GetUserCoordinatesService < BaseService
  LIMIT_LENGTH = 256

  def initialize(params:)
    super()
    @address = params[:address]
  end

  def call
    validate!
    return self if error?

    fetch_request
  end

  private

  def validate!
    add_error(I18n.t('errors.params.empty', param: :address)) if @address.blank?
  end

  def fetch_request
    get_user_coordinate_request = Mapbox::GetUserCoordinateRequest.call(@address)

    if get_user_coordinate_request.error?
      add_error(get_user_coordinate_request.first_error)
    else
      @result = get_user_coordinate_request.response
    end
  end
end
