class RemoveOrganizationsForeignKeyFromTaggings < ActiveRecord::Migration
  def change
    remove_foreign_key :taggings, column: :taggable_id
  end
end
