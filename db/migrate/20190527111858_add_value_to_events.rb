class AddValueToEvents < ActiveRecord::Migration[5.2]
  def change
    add_monetize :events, :value, amount: { null: true, default: nil }
  end
end
