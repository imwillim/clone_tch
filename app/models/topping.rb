class Topping < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { greater_than: 0, message: I18n.t('errors.models.topping.invalid_price') }
  belongs_to :product
end
