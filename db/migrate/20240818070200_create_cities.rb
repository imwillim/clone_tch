# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.index :name, unique: true
      t.index :code, unique: true
      t.timestamps
    end
  end
end
