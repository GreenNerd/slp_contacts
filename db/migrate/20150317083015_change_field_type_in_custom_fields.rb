class ChangeFieldTypeInCustomFields < ActiveRecord::Migration
  def change
    remove_column :slp_contacts_custom_fields, :field_type, :string
    add_column :slp_contacts_custom_fields, :field_type, :integer, default: 0
  end
end
