class CreateLeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :leaders do |t|
      t.string :mother_name
      t.string :father_name
      t.string :rg
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
