class CreateDrinkRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :drink_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :drink, null: false, foreign_key: true
      t.integer :consumed_ml, null: false
      t.datetime :consumed_at, null: false

      t.timestamps
    end
  end
end
