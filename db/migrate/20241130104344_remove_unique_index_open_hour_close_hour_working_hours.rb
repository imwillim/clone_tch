# frozen_string_literal: true

class RemoveUniqueIndexOpenHourCloseHourWorkingHours < ActiveRecord::Migration[7.1]
  def change
    remove_index :working_hours, [:open_hour, :close_hour], unique: true
  end
end
