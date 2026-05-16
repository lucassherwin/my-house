class AddEmailIndexToPeople < ActiveRecord::Migration[8.1]
  def change
    add_index :people, :email, unique: true
  end
end
