# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name, null: false
      t.string :color, null: false
      t.timestamps
      t.references :product, type: :uuid, foreign_key: true
    end
  end
end
