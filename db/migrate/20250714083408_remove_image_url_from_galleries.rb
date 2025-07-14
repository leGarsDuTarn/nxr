class RemoveImageUrlFromGalleries < ActiveRecord::Migration[7.1]
  def change
    remove_column :galleries, :image_url, :string
  end
end
