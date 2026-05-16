class Person < ApplicationRecord
  belongs_to :household, optional: true
  has_many :grocery_lists, foreign_key: "owner_id", dependent: :destroy
  has_secure_password

  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  normalizes :email, with: ->(e) { e.strip.downcase }
end
