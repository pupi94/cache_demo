# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |ex|
      logger.debug format("%s (%s):", ex.class.name, ex.message)
      logger.debug ex.backtrace.join("\n")
      render_not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |ex|
      logger.debug format("%s (%s):", ex.class.name, ex.message)
      logger.debug ex.backtrace.join("\n")
      render_unprocessable_entity(ex.record.errors.full_messages)
    end
  end
end
