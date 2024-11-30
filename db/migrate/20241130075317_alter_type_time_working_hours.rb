# frozen_string_literal: true

class AlterTypeTimeWorkingHours < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up { change_column :working_hours, :open_hour, 'time USING CAST(open_hour AS time)' }
      direction.up { change_column :working_hours, :close_hour, 'time USING CAST(close_hour AS time)' }

      direction.down { change_column :working_hours, :open_hour, :string }
      direction.down { change_column :working_hours, :close_hour, :string }
    end
  end
end
