class User < ActiveRecord::Base
  has_many :user_organizations
  has_many :organizations, through: :user_organizations
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  belongs_to :namespace

  def headimgurl_with_size(size = :tiny)
    headimgurl
  end
end
