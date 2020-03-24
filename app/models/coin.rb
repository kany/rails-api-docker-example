class Coin < ApplicationRecord
  attribute :quantity, type: Integer, default: 0

  def update_quantity!(count)
    self.quantity += Integer(count)
    save!
  end
end
