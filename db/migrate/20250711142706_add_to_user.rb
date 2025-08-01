class AddToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_name, :string
    add_column :users, :role, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :post_code, :string
    add_column :users, :town, :string
    add_column :users, :country, :string
    add_column :users, :phone_number, :string
  end
end
