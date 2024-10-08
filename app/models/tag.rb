# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true
  validates :color, presence: true
  belongs_to :product
end
