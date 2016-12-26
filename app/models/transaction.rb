class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :location

  scope :ordered, ->{order('square_created_at')}
end
