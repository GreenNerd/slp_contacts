class AddNamespaceToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :namespace, index: true
    add_foreign_key :users, :namespaces
  end
end
