class CreateGalleries < ActiveRecord::Migration[7.1]
  def change
    create_table :galleries do |t|
      t.string :title
      t.string :image_url
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
