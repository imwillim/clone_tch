# frozen_string_literal: true

class WorkingHour < ApplicationRecord
  validates :open_hour, presence: true
  validates :close_hour, presence: true
  validates :open_hour,
            uniqueness: { scope: :close_hour, message: I18n.t('errors.models.taken', record: :working_hour) }

  has_many :stores_working_hours, class_name: 'StoreWorkingHour', dependent: :destroy
  has_many :stores, through: :stores_working_hours
end
