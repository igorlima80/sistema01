class AddCpfToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :cpf, :string
  end
end
