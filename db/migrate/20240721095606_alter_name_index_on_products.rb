# frozen_string_literal: true

class AlterNameIndexOnProducts < ActiveRecord::Migration[7.0]
  def change
    remove_index :products, :name
    add_index :products, :name, unique: true
  end
end
