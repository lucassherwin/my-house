class CreateGroceryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :grocery_items, id: :uuid do |t|
      t.references :grocery_list, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :quantity
      t.text :notes
      t.boolean :in_cart, default: false, null: false

      t.timestamps
    end
  end
end
