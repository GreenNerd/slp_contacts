require 'digest/md5'

namespace = Namespace.create(name: "Skylark")

def generate_avatar
  email_address = Faker::Internet.email.downcase

  hash = Digest::MD5.hexdigest(email_address)
  "http://www.gravatar.com/avatar/#{hash}?d=wavatar"
end

Faker::Config.locale = 'zh-CN'

tags = []
10.times do
  tags << Tag.create(name: Faker::Address::country)
end

first_parent = Organization.create name: Faker::Company.name, namespace: namespace
second_parent = Organization.create name: Faker::Company.name, namespace: namespace
third_parent = Organization.create name: Faker::Company.name, namespace: namespace

def create_child_with_members(parent, tags, namespace)
  child = parent.children.create name: Faker::Company.name
  (rand(50) + 1).times do
    member = child.members.create name: Faker::Name.name,
                                  phone: Faker::PhoneNumber.phone_number,
                                  identifier: Faker::Number.number(10),
                                  remember_token: Faker::Number.number(20),
                                  headimgurl: generate_avatar,
                                  namespace: namespace
    (rand(10) + 1).times do
      tag = tags.sample
      member.tags << tag unless member.tags.include?(tag)
    end
  end
  create_child_with_members(child, tags, namespace) if rand(10) % 2 == 0
end

#first_parent
(rand(10) + 1).times do
  create_child_with_members(first_parent, tags, namespace)
end

#serond_parent
(rand(5) + 1).times do
  create_child_with_members(second_parent, tags, namespace)
end

#third_parent
create_child_with_members(third_parent, tags, namespace)

#custom_field
namespace.custom_fields.create(name: "年龄", field_type: 0)
namespace.custom_fields.create(name: "性别", field_type: 1, possible_values: "男,女")
namespace.custom_fields.create(name: "爱好", field_type: 2, possible_values: "吃,睡,玩")

#custom_value
User.all.each do |user|
  user.custom_values.create(value: rand(100), custom_field_id: 1)
  user.custom_values.create(value: "男", custom_field_id: 2)
  user.custom_values.create(value: "玩,吃", custom_field_id: 3)
end