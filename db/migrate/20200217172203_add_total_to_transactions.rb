class AddTotalToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :total, :float
  end
end
