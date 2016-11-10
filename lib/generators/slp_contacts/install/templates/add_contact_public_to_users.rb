class AddContactPublicToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :<%= contact_table_name %>, :contact_public, :boolean, default: true
  end
end
