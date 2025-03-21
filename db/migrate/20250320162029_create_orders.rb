class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.uuid :user_id
      t.uuid :store_id
      t.timestamps
    end
  end
end
