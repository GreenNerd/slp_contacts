class Organization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Organization'
  has_many :children, class_name: 'Organization', foreign_key: :parent_id, inverse_of: :parent
  has_many :user_organizations
  has_many :members, through: :user_organizations, source: :user
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
end
