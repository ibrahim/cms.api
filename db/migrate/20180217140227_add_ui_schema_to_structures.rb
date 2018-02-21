class AddUiSchemaToStructures < ActiveRecord::Migration[5.1]
  def change
    add_column :structures, :uischema, :text
  end
end
