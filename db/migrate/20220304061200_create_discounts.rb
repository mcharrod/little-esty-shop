class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.integer :min_quantity
      t.integer :percent
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
