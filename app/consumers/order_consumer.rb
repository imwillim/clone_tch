# frozen_string_literal: true

class OrderConsumer < ApplicationConsumer
  def consume
    messages.each { |message| puts message.payload }
  end
end
