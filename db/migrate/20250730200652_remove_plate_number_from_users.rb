class RemovePlateNumberFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :plate_number, :string
  end
end
