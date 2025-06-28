# frozen_string_literal: true

class ProductAudit < ApplicationRecord
  belongs_to :product

  validates :old_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :new_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :version, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
