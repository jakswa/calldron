class Number < ApplicationRecord
  belongs_to :account
  has_many :users, through: :account
  belongs_to :user
end
