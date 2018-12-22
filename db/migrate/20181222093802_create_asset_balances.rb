class CreateAssetBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_balances do |t|
      t.integer :amount, default: 0, null: false
      t.references :asset, foreign_key: true
      t.references :balance, foreign_key: true

      t.timestamps
    end
  end
end
