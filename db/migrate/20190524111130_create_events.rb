class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :final_date
      t.references :eventable, polymorphic: true
     

      t.timestamps
    end
  end
end
