class CreateEmojis < ActiveRecord::Migration[5.1]
  def change
    create_table :emojis do |t|
      t.string :emo
      t.string :code
      t.references :user, index: true, foreign_key: true
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
