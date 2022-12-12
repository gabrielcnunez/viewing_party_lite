class User < ApplicationRecord
  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  validates_presence_of :name, :email
  validates_uniqueness_of :email, case_sensitive: false
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates_presence_of :password_digest

  has_secure_password
end
