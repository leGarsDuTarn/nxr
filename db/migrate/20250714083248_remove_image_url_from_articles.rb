class RemoveImageUrlFromArticles < ActiveRecord::Migration[7.1]
  def change
    remove_column :articles, :image_url, :string
  end
end
