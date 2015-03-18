class AddHeadimgurlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :headimgurl, :string
  end
end
