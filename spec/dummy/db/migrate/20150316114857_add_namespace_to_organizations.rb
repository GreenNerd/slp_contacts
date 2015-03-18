class AddNamespaceToOrganizations < ActiveRecord::Migration
  def change
    add_reference :organizations, :namespace, index: true
    add_foreign_key :organizations, :namespaces
  end
end
