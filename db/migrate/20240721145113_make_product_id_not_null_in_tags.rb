# frozen_string_literal: true

class MakeProductIdNotNullInTags < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tags, :product_id, false
  end
end
