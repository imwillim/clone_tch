# frozen_string_literal: true

class MakeProductIdNotNullInToppings < ActiveRecord::Migration[7.0]
  def change
    change_column_null :toppings, :product_id, false
  end
end
