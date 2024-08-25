# frozen_string_literal: true

class CreateFacilities < ActiveRecord::Migration[7.1]
  def change
    create_table :facilities, id: :uuid do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :icon
      t.timestamps
    end
  end
end
