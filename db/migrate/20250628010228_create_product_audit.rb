# frozen_string_literal: true

class CreateProductAudit < ActiveRecord::Migration[8.0]
  def change
    create_table :product_audits, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.decimal :old_price, precision: 10, scale: 2, null: false
      t.decimal :new_price, precision: 10, scale: 2, null: false
      t.integer :version, null: false
      t.timestamps
      t.foreign_key :products, column: :product_id
    end

    add_index :product_audits, :product_id
  end
end
