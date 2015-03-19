Fabricator(:custom_value, class_name: 'SlpContacts::CustomValue') do
  custom_field
  value          { sequence(:name) { |i| "Value-#{i}"  }  }
  user
end
