class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.integer :type_issue
      t.string :subject
      t.text :description
      t.string :status
      t.integer :priority
      t.string :assignee
      t.datetime :start_date
      t.datetime :expired_date
      t.string :estimate_time, default: "0.00"
      t.string :percent_progress
      t.integer :parent_id
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.integer :issue_template_id, foreign_key: true

      t.timestamps
    end
  end
end
