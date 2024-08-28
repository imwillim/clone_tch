# frozen_string_literal: true

class CreateStoresWorkingHours < ActiveRecord::Migration[7.1]
  def change
    create_table :stores_working_hours, id: :uuid do |t|
      t.string :day, null: false
      t.references :store, null: false, foreign_key: true
      t.references :working_hour, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
    add_index :stores_working_hours, %i[day store_id]
  end
end
