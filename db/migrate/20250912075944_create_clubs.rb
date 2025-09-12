class CreateClubs < ActiveRecord::Migration[7.1]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :affiliation_number, null: false, default: "C0637"
      t.string :address
      t.string :post_code
      t.string :town
      t.string :phone_number
      t.string :email
      t.string :president_name
      t.string :responsable_communication_name

      t.timestamps
    end

    add_index :clubs, :affiliation_number, unique: true
  end
end
