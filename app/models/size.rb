# frozen_string_literal: true

class Size < ApplicationRecord
  validates :name, presence: true
  validates :icon, presence: true
  validates :price, numericality: {
    greater_than: 0,
    message: I18n.t('errors.models.invalid_price', record: :size)
  }

  belongs_to :product
end
