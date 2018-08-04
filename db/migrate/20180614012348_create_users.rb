class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login_name
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :password
      t.integer :user_type, default:1
      t.boolean :status, default:true
      t.boolean :email_notice, default:false
      t.boolean :hide_email, default:false
      t.datetime :last_login
      t.string :provider, default: "none"
      t.string :uid, default: "none"
      t.timestamps
    end
  end
end
