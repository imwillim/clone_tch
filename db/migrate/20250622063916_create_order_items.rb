# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :order_items, id: :bigint do |t|
      t.uuid :order_id, null: false
      t.uuid :product_id, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.float :discount, default: 0.0
      t.integer :version, default: 1

      t.timestamps
    end

    add_foreign_key :order_items, :orders, column: :order_id
    add_foreign_key :order_items, :products, column: :product_id
  end

  # rubocop:enable Metrics/MethodLength
end
