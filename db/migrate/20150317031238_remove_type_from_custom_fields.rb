class RemoveTypeFromCustomFields < ActiveRecord::Migration
  def change
    remove_column :slp_contacts_custom_fields, :type, :string
  end
end
