class CreateIssueRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :issue_relationships do |t|
      t.integer :type_relationship
      t.integer :issue_relation
      t.integer :project_id
      t.references :issue, index: true, foreign_key: true

      t.timestamps
    end
  end
end
