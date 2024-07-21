# frozen_string_literal: true

class CreateSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :sizes, id: :uuid do |t|
      t.string :name, null: false
      t.string :icon, null: false
      t.decimal :price, null: false
      t.timestamps
      t.references :product, foreign_key: true, type: :uuid
    end
  end
end
