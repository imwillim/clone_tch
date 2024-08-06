# frozen_string_literal: true

module ErrorHandling
  def render_invalid_params(exception)
    render json: { errors: exception.message }, status: :bad_request
  end
end
