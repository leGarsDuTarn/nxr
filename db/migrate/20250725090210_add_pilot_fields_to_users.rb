class AddPilotFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :birth_date, :date
    add_column :users, :license_code, :string
    add_column :users, :license_number, :string
    add_column :users, :club_member, :boolean
    add_column :users, :bike_brand, :string
    add_column :users, :cylinder_capacity, :integer
    add_column :users, :stroke_type, :string
    add_column :users, :plate_number, :string
  end
end
