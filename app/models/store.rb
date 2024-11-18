# frozen_string_literal: true

class Store < ApplicationRecord
  validates :name, presence: true

  has_one :address, dependent: :destroy
  has_one :city, through: :address

  has_many :facilities_stores, class_name: 'FacilityStore', dependent: :destroy
  has_many :facilities, through: :facilities_stores

  has_many :working_hours, dependent: :destroy
end
