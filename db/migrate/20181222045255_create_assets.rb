class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.string :name, null: false
      t.monetize :price
      t.boolean :soft_deleted, default: false

      t.timestamps
    end
    add_index :assets, :name, unique: true
  end
end
