Fabricator(:custom_field, class_name: 'SlpContacts::CustomField') do
  name            { sequence(:name) { |i| "Name-#{i}"  }  }
  field_type      "input"
  possible_values "MyString"
  is_required     false
  is_unique       false
  editable        false
  visible         false
end
