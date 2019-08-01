# frozen_string_literal: true

module RenderHelper
  extend ActiveSupport::Concern

  def render_not_found(errors = "record not found")
    render json: { errors: errors }, status: :not_found
  end

  def render_ok(opts = {})
    render json: opts, status: :ok
  end

  def render_unprocessable_entity(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_internal_server_error(errors = "internal server error")
    render json: { errors: errors }, status: :internal_server_error
  end
end
