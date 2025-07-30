class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.string :symbol
      t.integer :shares
      t.decimal :price

      t.timestamps
    end
  end
end
