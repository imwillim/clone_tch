# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ErrorHandling

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

  rescue_from Redis::BaseError, with: :render_redis_error
  rescue_from JWT::EncodeError, with: :render_encode_jwt_error
  rescue_from JWT::DecodeError, with: :render_decode_jwt_error

  rescue_from ::CustomErrors::InvalidParams, with: :render_invalid_params
  rescue_from ::CustomErrors::UnprocessableService, with: :render_unprocessable_service
  rescue_from ::CustomErrors::UnauthorizedError, with: :render_unauthorized

  before_action do
    raise ::CustomErrors::InvalidParams, safe_params.errors(full: true).messages.join(', ') if safe_params&.failure?
  end

  def authenticate_token
    token = request.headers['Authorization']

    raise ::CustomErrors::UnauthorizedError, 'Unauthorized' if token.blank?
    raise ::CustomErrors::UnauthorizedError, 'Token invalid' if CacheManager.exists?("black_list #{token}")

    payload = JsonWebTokenManager.decode(token)

    raise ::CustomErrors::UnauthorizedError, 'Token timeout' if payload['exp'] < Time.now.to_i

    current_user_with_payload(payload)
  end

  private

  def current_user_with_payload(payload)
    @current_user = User.find(payload['user_id'])
  end
end
