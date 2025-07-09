# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :store

  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  has_many :items, through: :order_items, source: :product
  after_commit :publish_order_created_event, on: :create

  def publish_order_created_event
    Karafka.producer.produce_async(
      topic: 'order_created',
      payload: {
        order_id: id,
        user_id: user_id,
        store_id: store_id,
      }.to_json
    )
    # rescue StandardError => e
    #   Rails.logger.error("Failed to publish order created event: #{e.message}")
    # end
  end
end
