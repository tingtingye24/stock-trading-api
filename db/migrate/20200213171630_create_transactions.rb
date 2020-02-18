class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :ticker
      t.integer :stock_amount
      t.float :price
      t.timestamps
    end
  end
end
