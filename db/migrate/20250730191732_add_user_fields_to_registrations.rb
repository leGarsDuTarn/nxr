class AddUserFieldsToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :bike_brand, :string
    add_column :registrations, :cylinder_capacity, :integer
    add_column :registrations, :stroke_type, :string
    add_column :registrations, :race_number, :string
  end
end
