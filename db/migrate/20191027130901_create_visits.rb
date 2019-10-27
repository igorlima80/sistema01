class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.date :date_visit
      t.text :observation
      t.integer :number_of_voters
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
