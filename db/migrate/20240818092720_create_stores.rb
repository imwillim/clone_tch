# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.string :image_urls, array: true, default: []
      t.timestamps
    end
  end
end
