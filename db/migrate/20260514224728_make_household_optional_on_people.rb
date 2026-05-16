class MakeHouseholdOptionalOnPeople < ActiveRecord::Migration[8.1]
  def change
    change_column_null :people, :household_id, true
  end
end
