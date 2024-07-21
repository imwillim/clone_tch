# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.decimal :price, null: false
      t.string :thumbnail
      t.string :image_urls, array: true, default: []
      t.timestamps
    end
    add_index :products, :name
  end
end
