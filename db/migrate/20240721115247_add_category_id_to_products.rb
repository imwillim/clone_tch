# frozen_string_literal: true

class AddCategoryIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :category, null: false, foreign_key: true, type: :uuid # rubocop:disable Rails/NotNullColumn
  end
end
