class AddIsActiveToGroceryList < ActiveRecord::Migration[8.1]
  def change
    add_column :grocery_lists, :is_active, :boolean, default: true
  end
end
