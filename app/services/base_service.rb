# frozen_string_literal: true

class BaseService
  attr_reader :result

  def self.call(...)
    service = new(...)
    service.call
    service
  end

  def errors
    @errors ||= []
  end

  def success?
    errors.empty?
  end

  def error?
    !success?
  end

  def add_error(error)
    return if error.blank?

    case error
    when Array
      error.each { |e| add_error(e) }
    else
      err = StandardError.new(error)
      err.set_backtrace(caller)
      errors << err
    end
  end

  def first_error
    errors.first
  end

  def notify_error
    # TODO: Implement soon
  end
end
