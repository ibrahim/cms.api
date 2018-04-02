class Frame < ApplicationRecord
  belongs_to :page, optional: true
  belongs_to :photo, class_name: 'Photo', foreign_key: 'photo_id', optional: true
  serialize :background_positions
  serialize :tags, Array
  acts_as_nested_set :scope => :page_id
end
