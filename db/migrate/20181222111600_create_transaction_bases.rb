class CreateTransactionBases < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_bases do |t|
      t.monetize :amount
      t.string :name, limit: 30, default: SecureRandom.urlsafe_base64, null: false
      t.boolean :approved, null: true
      t.string :type
      t.references :user, foreign_key: true
      t.references :asset, foreign_key: true

      t.timestamps
    end
    add_index :transaction_bases, :name, unique: true
  end
end
