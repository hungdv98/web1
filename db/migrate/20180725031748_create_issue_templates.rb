class CreateIssueTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :issue_templates do |t|
      t.string :name
      t.integer :type_template
      t.text :description
      t.references :user

      t.timestamps
    end
  end
end
