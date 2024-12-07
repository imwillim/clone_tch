# frozen_string_literal: true

class AddStoredColumnAddressStores < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :computed_address, :virtual, type: :string,
               as: "house_number || ' ' || street || ', ' || ward || ', ' || district",
               stored: true
  end
end
