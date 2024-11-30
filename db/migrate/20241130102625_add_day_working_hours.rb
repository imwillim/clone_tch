# frozen_string_literal: true

class AddDayWorkingHours < ActiveRecord::Migration[7.1]
  def change
    add_column :working_hours, :day, :string
  end
end
