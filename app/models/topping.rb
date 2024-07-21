class Topping < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: {
    greater_than: 0, message: I18n.t('errors.models.invalid_price', record: :topping)
  }
  belongs_to :product
end
