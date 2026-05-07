class GroceryList < ApplicationRecord
  belongs_to :household
  belongs_to :owner, class_name: "Person"
  has_many :grocery_items
end
