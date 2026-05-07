class Household < ApplicationRecord
  has_many :people
  has_many :grocery_lists
end
