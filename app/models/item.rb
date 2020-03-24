class Item < ApplicationRecord
  attribute :name, type: String
  attribute :quantity, type: Integer, default: 5
  attribute :price, type: Integer, default: 2

  validates_presence_of :name
end
