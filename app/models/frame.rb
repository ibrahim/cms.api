class Frame < ApplicationRecord
  belongs_to :page
  belongs_to :photo, class_name: 'Photo', foreign_key: 'photo_id'
  serialize :background_positions
  acts_as_nested_set :scope => :page_id
end
