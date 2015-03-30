class AddNamespaceToCustomField < ActiveRecord::Migration
  def change
    add_foreign_key :slp_contacts_custom_fields, :namespaces
  end
end
