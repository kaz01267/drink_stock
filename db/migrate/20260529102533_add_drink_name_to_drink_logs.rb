class AddDrinkNameToDrinkLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :drink_logs, :drink_name, :string
  end
end
