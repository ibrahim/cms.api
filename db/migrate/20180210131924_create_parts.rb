class CreateParts < ActiveRecord::Migration[5.1]
  def change
    create_table :parts do |t|
      t.integer :page_id, :structure_id
      t.text    :content , :limit => 2.megabytes
      t.column  :locale, "char(2)"
    end
    execute "CREATE UNIQUE INDEX page_locale ON parts (page_id, locale)"
  end
end
