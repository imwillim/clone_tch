# frozen_string_literal: true

class DropJoinTableStoresWorkingHours < ActiveRecord::Migration[7.1]
  def change
    drop_join_table :stores, :working_hours
  end
end
