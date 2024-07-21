class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: "Price of product must be greater than 0" }
  validates :name, presence: true
  validates :thumbnail, presence: true
  validates :description, presence: true
end
