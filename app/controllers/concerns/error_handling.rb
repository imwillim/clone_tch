# frozen_string_literal: true

module ErrorHandling
  def render_invalid_params(exception)
    render json: { errors: exception.message }, status: :bad_request
  end

  def render_unprocessable_service(error)
    render json: { errors: error }, status: :unprocessable_entity
  end

  def render_unauthorized(error)
    render json: { errors: error }, status: :unauthorized
  end

  def render_redis_error(error)
    Rails.logger.error(error)
    render json: { errors: 'Internal Server Error' }, status: :internal_server_error
  end

  def render_not_found(error)
    render json: { errors: error }, status: :not_found
  end

  def render_invalid_record(error)
    render json: { message: error.to_s }, status: :unprocessable_entity
  end

  def render_encode_jwt_error(error)
    Rails.logger.error(error)
    render json: { errors: 'Internal Server Error' }, status: :internal_server_error
  end

  def render_decode_jwt_error(error)
    Rails.logger.error(error)
    render json: { errors: 'Login failed' }, status: :unauthorized
  end
end
