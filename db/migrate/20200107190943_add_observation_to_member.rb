class AddObservationToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :observation, :text
  end
end
