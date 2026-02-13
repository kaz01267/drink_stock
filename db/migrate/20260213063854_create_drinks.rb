class CreateDrinks < ActiveRecord::Migration[7.2]
  def change
    create_table :drinks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :stock_ml

      t.timestamps
    end
  end
end
