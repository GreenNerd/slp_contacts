class CreateSlpContactsCustomFields < ActiveRecord::Migration
  def change
    create_table :slp_contacts_custom_fields do |t|
      t.integer :namespace_id
      t.string :name
      t.string :type
      t.string :field_type
      t.string :possible_values
      t.boolean :is_required
      t.boolean :is_unique
      t.boolean :editable
      t.boolean :visible

      t.timestamps null: false
    end
  end
end
