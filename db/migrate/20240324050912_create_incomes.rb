# frozen_string_literal: true

class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes do |t|
      t.integer :user_id
      t.decimal :amount
      t.string :source
      t.date :date

      t.timestamps
    end
  end
end
