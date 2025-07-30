class RemoveBikeBrandEtcFromUsers < ActiveRecord::Migration[7.1]
  def up
    # On vide d'abord toutes les données des colonnes
    User.update_all(bike_brand: nil, cylinder_capacity: nil, stroke_type: nil, race_number: nil)

    # Puis on supprime les colonnes
    remove_column :users, :bike_brand, :string
    remove_column :users, :cylinder_capacity, :integer
    remove_column :users, :stroke_type, :string
    remove_column :users, :race_number, :string
  end

  def down
    # Si on rollback, on recrée les colonnes (vides)
    add_column :users, :bike_brand, :string
    add_column :users, :cylinder_capacity, :integer
    add_column :users, :stroke_type, :string
    add_column :users, :race_number, :string
  end
end
