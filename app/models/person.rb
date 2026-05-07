class Person < ApplicationRecord
  belongs_to :household
  has_many :grocery_lists, foreign_key: "owner_id", dependent: :destroy
  has_secure_password
end
