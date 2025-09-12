class AddPricesToRaces < ActiveRecord::Migration[7.1]
  def change
    # 8 chiffres avant la virgule, 2 chiffres après la virgule
    add_column :races, :club_member_price, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :races, :non_club_member_price, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
