class AddRaceNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :race_number, :string
  end
end
