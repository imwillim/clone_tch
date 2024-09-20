# frozen_string_literal: true

class GetUserCoordinatesService < BaseService
  LIMIT_LENGTH = 256

  def initialize(params:)
    super()
    @ward = params[:ward]
    @district = params[:district]
  end

  def call
    validate!
    return self if error?

    fetch_request
  end

  private

  def validate!
    return add_error(I18n.t('errors.params.empty', param: :address_search)) if address_search.blank?

    add_error(I18n.t('errors.params.too_long', param: :address_search)) if address_search.length > LIMIT_LENGTH
  end

  def address_search
    "#{@ward} #{@district}"
  end

  def fetch_request
    get_user_coordinate_request = Mapbox::GetUserCoordinateRequest.call(address_search:)

    if get_user_coordinate_request.error?
      add_error(get_user_coordinate_request.first_error)
    else
      @result = get_user_coordinate_request.response
    end
  end
end
