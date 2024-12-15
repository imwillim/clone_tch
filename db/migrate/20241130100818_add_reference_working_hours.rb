# frozen_string_literal: true

class AddReferenceWorkingHours < ActiveRecord::Migration[7.1]
  def change
    add_reference :working_hours, :store, foreign_key: true
  end
end
