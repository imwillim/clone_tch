# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true
  validates :color, presence: true

  has_and_belongs_to_many :products
end
