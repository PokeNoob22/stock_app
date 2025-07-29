class AddOfficialTraderToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :official_trader, :string, default: "Pending"
  end
end
