class CreateSlpContactsCustomValues < ActiveRecord::Migration
  def change
    create_table :slp_contacts_custom_values do |t|
      t.integer :custom_field_id
      t.string :value
      t.integer :user_id

      t.timestamps null: false
    end

    add_foreign_key :slp_contacts_custom_values, :users
    add_foreign_key :slp_contacts_custom_values, :slp_contacts_custom_fields, column: :custom_field_id
  end
end
