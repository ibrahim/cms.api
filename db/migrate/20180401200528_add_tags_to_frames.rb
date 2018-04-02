class AddTagsToFrames < ActiveRecord::Migration[5.1]
  def change
    change_table :frames do |t|
      t.string :tags
    end
  end
end
