# frozen_string_literal: true

class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: I18n.t('errors.models.product.invalid_price') }
  validates :name, presence: true
  validates :thumbnail, presence: true
  validates :description, presence: true
end
