class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :ibge
      t.references :state, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :cities, [:latitude, :longitude]
  end
end
