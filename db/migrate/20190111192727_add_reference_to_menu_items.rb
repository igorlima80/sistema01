class AddReferenceToMenuItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :menu_items, :menu_item, foreign_key: true
  end
end
