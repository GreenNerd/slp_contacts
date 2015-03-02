class CreateSlpContactsFavorites < ActiveRecord::Migration
  def change
    create_table :slp_contacts_favorites do |t|
      t.belongs_to :user, index: true
      t.belongs_to :contact, index: true

      t.timestamps null: false
    end
    add_foreign_key :slp_contacts_favorites, :users
    add_foreign_key :slp_contacts_favorites, :users, column: :contact_id
  end
end
