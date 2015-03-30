Fabricator(:namespace, class_name: SlpContacts.namespace_class.to_s) do
  name { sequence(:name) { |i| "Name-#{i}"  }  }
end

