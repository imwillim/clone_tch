# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :addresses, id: :uuid do |t|
      t.string :house_number, null: false
      t.string :street, null: false
      t.string :ward, null: false
      t.string :district, null: false
      t.numeric :latitude
      t.numeric :longitude
      t.timestamps

      t.references :city, type: :uuid, foreign_key: true
      t.references :store, index: { unique: true }, foreign_key: true
    end
    add_index :addresses, %i[house_number street ward district], unique: true
  end
end
