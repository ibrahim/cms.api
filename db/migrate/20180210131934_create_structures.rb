class CreateStructures < ActiveRecord::Migration[5.1]
  def change
    create_table :structures do |t|
      t.integer :site_id
      t.string  :name, :limit => 10
      t.integer :public, :limit => 1
      t.text :schema
    end
  end
end
