class AddActiveToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :active, :boolean, default: true
  end
end
