class CreateCoins < ActiveRecord::Migration[5.2]
  def change
    create_table :coins do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
