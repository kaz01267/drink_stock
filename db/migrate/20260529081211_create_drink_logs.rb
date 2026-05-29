class CreateDrinkLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :drink_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :drink, null: false, foreign_key: true
      t.text :memo
      t.integer :rating
      t.datetime :logged_at

      t.timestamps
    end
  end
end
