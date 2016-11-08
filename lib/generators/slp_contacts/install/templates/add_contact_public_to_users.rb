class AddContactPublicToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :<%= contact_table_name %>, :contact_public, :boolean, default: true

    <%= contact_class_name %>.all.update_all contact_public: true
  end
end
