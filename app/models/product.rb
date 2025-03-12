# frozen_string_literal: true

class Product < ApplicationRecord
  validates :price, numericality: { greater_than: 0, message: I18n.t('errors.models.invalid_price', record: :product) }
  validates :name, presence: true, uniqueness: true
  validates :thumbnail, presence: true
  validates :description, presence: true
  has_many :sizes, dependent: :destroy
  has_many :toppings, dependent: :destroy
  belongs_to :category

  after_update :update_cache
  after_destroy :invalidate_cache

  private

  def update_cache
    CacheManager.unassign_value(id)
    CacheManager.assign_value(id, to_json)
  end

  def invalidate_cache
    CacheManager.unassign_value(id)
  end
end
