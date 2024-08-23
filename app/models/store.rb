# frozen_string_literal: true

class Store < ApplicationRecord
  validates :name, presence: true

  has_one :address, dependent: :nullify
  has_one :city, through: :address
end
