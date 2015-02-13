class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :taggable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_foreign_key :taggings, :tags
    add_foreign_key :taggings, :users, column: :taggable_id
    add_foreign_key :taggings, :organizations, column: :taggable_id
  end
end
