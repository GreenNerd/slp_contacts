class Organization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Organization'
  has_many :children, class_name: 'Organization', foreign_key: :parent_id, inverse_of: :parent
end
