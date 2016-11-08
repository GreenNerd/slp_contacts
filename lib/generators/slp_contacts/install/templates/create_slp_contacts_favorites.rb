class CreateSlpContactsFavorites < ActiveRecord::Migration
  def change
    create_table :slp_contacts_favorites do |t|
      t.belongs_to :user, index: true
      t.belongs_to :contact, index: true

      t.timestamps null: false
    end
    add_foreign_key :slp_contacts_favorites, :<%= contact_table_name %>
    add_foreign_key :slp_contacts_favorites, :<%= contact_table_name %>, column: :contact_id
  end
end
