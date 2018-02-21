class CreatePagesStructuresTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pages_structures do |t|
      t.integer :page_id
      t.integer :structure_id
    end
    add_index :pages_structures, :page_id
  end
end
