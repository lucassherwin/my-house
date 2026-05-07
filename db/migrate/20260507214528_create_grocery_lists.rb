class CreateGroceryLists < ActiveRecord::Migration[8.1]
  def change
    create_table :grocery_lists, id: :uuid do |t|
      t.references :household, null: false, foreign_key: true, type: :uuid
      t.references :owner, null: false, foreign_key: { to_table: :people }, type: :uuid

      t.timestamps
    end
  end
end
