# frozen_string_literal: true

class Facility < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :facilities_stores, class_name: 'FacilityStore', dependent: :destroy
  has_many :stores, through: :facilities_stores
end
