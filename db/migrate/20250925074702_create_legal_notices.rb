class CreateLegalNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_notices do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
