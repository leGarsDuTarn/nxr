class AddUniqueIndexToRegistrations < ActiveRecord::Migration[7.1]
  def change
    # Ajoute un index unique qui enléve la possibilité à un utilisateur
    # de s'inscrire plusieurs fois à la même activité (race, trainings, event)
    add_index :registrations, [:user_id, :registerable_type, :registerable_id], unique: true
  end
end
