# frozen_string_literal: true

module CustomErrors
  class BaseError < StandardError
    def initialize(msg = nil)
      super
    end
  end

  class InvalidParams < BaseError; end

  class UnprocessableService < BaseError; end
end
