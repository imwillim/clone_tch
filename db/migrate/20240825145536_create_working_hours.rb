# frozen_string_literal: true

class CreateWorkingHours < ActiveRecord::Migration[7.1]
  def change
    create_table :working_hours, id: :uuid do |t|
      t.string :open_hour, null: false
      t.string :close_hour, null: false
      t.timestamps
    end
    add_index :working_hours, %i[open_hour close_hour], unique: true
  end
end
