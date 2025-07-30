class StockHolding < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true
  validates :shares, numericality: { greater_than_or_equal_to: 0 }
end
