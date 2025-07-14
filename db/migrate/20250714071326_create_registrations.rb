class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :registerable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
