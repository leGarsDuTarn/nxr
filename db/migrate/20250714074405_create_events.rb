class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.date :date
      t.time :hour
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
