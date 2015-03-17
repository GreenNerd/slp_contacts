require 'digest/md5'

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

first_namespace = Namespace.create name: Faker::Name.name
second_namespace = Namespace.create name: Faker::Name.name
third_namespace = Namespace.create name: Faker::Name.name

first_parent = Organization.create name: Faker::Company.name, namespace: first_namespace
second_parent = Organization.create name: Faker::Company.name, namespace: second_namespace
third_parent = Organization.create name: Faker::Company.name, namespace: third_namespace

def create_child_with_members(parent, tags)
  child = parent.children.create name: Faker::Company.name, namespace: parent.namespace
  (rand(50) + 1).times do
    member = child.members.create name: Faker::Name.name,
                                  phone: Faker::PhoneNumber.phone_number,
                                  identifier: Faker::Number.number(10),
                                  remember_token: Faker::Number.number(20),
                                  headimgurl: generate_avatar,
                                  namespace: child.namespace
    (rand(10) + 1).times do
      tag = tags.sample
      member.tags << tag unless member.tags.include?(tag)
    end
  end
  create_child_with_members(child, tags) if rand(10) % 2 == 0
end

#first_parent
(rand(10) + 1).times do
  create_child_with_members(first_parent, tags)
end

#serond_parent
(rand(5) + 1).times do
  create_child_with_members(second_parent, tags)
end

#third_parent
create_child_with_members(third_parent, tags)

