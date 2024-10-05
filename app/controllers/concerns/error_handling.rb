# frozen_string_literal: true

module ErrorHandling
  def render_invalid_params(exception)
    render json: { errors: exception.message }, status: :bad_request
  end

  def render_internal_error(exception)
    render json: { errors: exception.message }, status: :internal_error_server
  end

  def render_unprocessable_service(error)
    render json: { errors: error }, status: :unprocessable_entity
  end
end
