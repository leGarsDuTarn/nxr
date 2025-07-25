class AddClubNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :club_name, :string
  end
end
