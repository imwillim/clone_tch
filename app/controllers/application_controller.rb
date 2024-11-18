# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ErrorHandling

  rescue_from ::CustomErrors::InvalidParams, with: :render_invalid_params
  rescue_from ::CustomErrors::UnprocessableService, with: :render_unprocessable_service
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Redis::BaseError, with: :render_redis_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

  before_action do
    raise ::CustomErrors::InvalidParams, safe_params.errors(full: true).messages.join(', ') if safe_params&.failure?
  end
end
