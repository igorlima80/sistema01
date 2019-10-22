class AddBirthDateToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :birthdate, :date
  end
end
