# frozen_string_literal: true

class StoreWorkingHour < ApplicationRecord
  self.table_name = 'stores_working_hours'
  VALID_DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  validates :day, presence: true,
                  inclusion: { in: VALID_DAYS, message: I18n.t('errors.models.not_valid', record: :day) }

  belongs_to :store
  belongs_to :working_hour
end
