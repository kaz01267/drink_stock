class ChangeDrinkIdNullOnDrinkLogs < ActiveRecord::Migration[7.2]
  def change
    change_column_null :drink_logs, :drink_id, true
  end
end
