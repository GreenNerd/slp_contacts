class CreateUserOrganizations < ActiveRecord::Migration
  def change
    create_table :user_organizations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :organization, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_organizations, :users
    add_foreign_key :user_organizations, :organizations
  end
end
