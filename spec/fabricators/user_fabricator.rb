Fabricator(:user, class_name: SlpContacts.contact_class.to_s, aliases: [:contact]) do
  namespace
  name { sequence(:name) { |i| "Name-#{i}"  }  }
  phone { sequence(:phone) { |i| 18683255107 + i }  }
  identifier { sequence(:identifier) { |i| rand(999_999_999) + i } }
end

