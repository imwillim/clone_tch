# frozen_string_literal: true

class MakeProductIdNotNullInSizes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sizes, :product_id, false
  end
end
