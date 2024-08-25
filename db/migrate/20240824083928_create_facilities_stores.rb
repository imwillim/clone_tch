# frozen_string_literal: true

class CreateFacilitiesStores < ActiveRecord::Migration[7.1]
  def change
    create_table :facilities_stores, primary_key: %i[store_id facility_id] do |t|
      t.references :store, null: false, foreign_key: true
      t.references :facility, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
