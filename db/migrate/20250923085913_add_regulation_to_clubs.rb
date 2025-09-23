class AddRegulationToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :participation_terms, :text
  end
end
