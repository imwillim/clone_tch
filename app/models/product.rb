# frozen_string_literal: true

class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: I18n.t('errors.models.invalid_price', record: :product) }
  validates :name, presence: true
  validates :thumbnail, presence: true
  validates :description, presence: true
  has_many :sizes, dependent: :destroy
  has_many :toppings, dependent: :destroy
  has_one :tag, dependent: :destroy
end
