# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true
  validates :color, presence: true

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :products
  # rubocop:enable Rails/HasAndBelongsToMany
end
