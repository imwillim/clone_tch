# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.timestamps
      t.references :parent, null: true, foreign_key: { to_table: :categories }, type: :uuid
    end
  end
end
