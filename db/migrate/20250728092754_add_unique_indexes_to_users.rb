class AddUniqueIndexesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :plate_number, unique: true
    add_index :users, :license_number, unique: true
    add_index :users, :race_number, unique: true
  end
end
