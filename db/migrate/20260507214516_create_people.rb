class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people, id: :uuid do |t|
      t.references :household, null: false, foreign_key: true, type: :uuid
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
