# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone
      t.string :address
      t.timestamp :verified_at
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
