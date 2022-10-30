class AddUrlsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :short_urls do |t|
      t.string :original_url, null: false
      t.string :short_id, null: false

      t.index [:original_url, :short_id], unique: true
      t.index :short_id, unique: true

      t.timestamps
    end
  end
end
