class AddGeneratedPasswordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :generated_password, :string
  end
end
