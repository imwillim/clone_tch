# frozen_string_literal: true

class City < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  has_many :addresses, dependent: :nullify
  has_many :stores, through: :addresses
end
