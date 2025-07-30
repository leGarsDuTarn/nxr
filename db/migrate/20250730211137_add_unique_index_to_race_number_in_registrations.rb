class AddUniqueIndexToRaceNumberInRegistrations < ActiveRecord::Migration[7.1]
  def change
    # Un même numéro de course ne peut pas être réutilisé sur le même événement (qu'il s'agisse d'une Race, Event ou Training).
    # Mais un race_number pourra être réutilisé sur un autre événement.
    add_index :registrations, [:race_number, :registerable_id, :registerable_type],
    unique: true,
    name: 'index_registrations_on_race_number_and_registerable'
  end
end
