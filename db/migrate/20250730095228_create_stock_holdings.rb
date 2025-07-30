class CreateStockHoldings < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_holdings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.integer :shares

      t.timestamps
    end
  end
end
