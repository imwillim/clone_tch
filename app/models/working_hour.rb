# frozen_string_literal: true

class WorkingHour < ApplicationRecord
  validates :open_hour, presence: true
  validates :close_hour, presence: true
end
