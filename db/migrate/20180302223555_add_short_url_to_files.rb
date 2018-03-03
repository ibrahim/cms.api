class AddShortUrlToFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :downloads, :short_url, :string
  end
end
