class AddCellPhoneToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :cell_phone, :string
  end
end
