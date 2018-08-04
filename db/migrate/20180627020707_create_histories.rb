class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.references :issue, index: true, foreign_key: true
      t.string :type_issue
      t.string :subject
      t.text :description
      t.string :status
      t.string :priority
      t.string :assignee
      t.string :start_date
      t.string :expired_date
      t.string :estimate_time
      t.string :percent_progress
      t.string :parent_id
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end

