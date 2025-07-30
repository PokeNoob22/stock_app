class Transaction < ApplicationRecord
  belongs_to :user

  validates :transaction_type, presence: true, inclusion: { in: ['buy', 'sell'] }
  validates :symbol, presence: true
  validates :shares, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
