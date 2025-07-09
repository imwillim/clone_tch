# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :discount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :version, numericality: { only_integer: true, greater_than: 0 }

  after_save :update_order_total

  def update_order_total
    total = order.order_items.sum do |item|
      item.price * item.quantity * (1 - (item.discount || 0))
    end
    order.update(total_price: total)
  end
end
