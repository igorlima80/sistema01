class MenuItem < ApplicationRecord
  belongs_to :menu_item, optional: true
  has_many :menu_items

  scope :published, -> { where(published: true).order(position: :asc) }
  scope :root, -> { where(menu_item_id: nil).order(position: :asc)}
  scope :sidebar, -> { where(published: true).order(position: :asc) }
end
