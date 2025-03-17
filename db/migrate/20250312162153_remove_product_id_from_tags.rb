# frozen_string_literal: true

class RemoveProductIdFromTags < ActiveRecord::Migration[8.0]
  def change
    remove_index :tags, :product_id
    remove_column :tags, :product_id, :uuid
  end
end
