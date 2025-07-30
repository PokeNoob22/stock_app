class AddBalanceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :balance, :decimal
  end
end
