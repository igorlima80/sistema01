class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.references :leader, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
