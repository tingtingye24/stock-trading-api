class AddWalletToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wallet, :float, :default => 5000
  end
end
