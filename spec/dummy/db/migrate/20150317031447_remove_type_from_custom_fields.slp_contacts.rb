# This migration comes from slp_contacts (originally 20150317031238)
class RemoveTypeFromCustomFields < ActiveRecord::Migration
  def change
    remove_column :slp_contacts_custom_fields, :type
  end
end
