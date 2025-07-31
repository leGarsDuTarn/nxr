class AddClubAffiliationNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :club_affiliation_number, :string
  end
end
