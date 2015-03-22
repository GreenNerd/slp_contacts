Fabricator(:custom_field, class_name: 'SlpContacts::CustomField') do
  namespace
  name            { sequence(:name) { |i| "Name-#{i}"  }  }
  field_type      "input"
  possible_values "MyString"
  is_required     true
  is_unique       true
  editable        false
  visible         false
end
