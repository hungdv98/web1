class AddPicturesToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :pictures, :json
  end
end
