Fabricator(:custom_field, class_name: 'SlpContacts::CustomField') do
  namespace
  name            { sequence(:name) { |i| "Name-#{i}"  }  }
  field_type      "输入框"
  possible_values "MyString"
  is_required     true
  is_unique       true
  editable        false
  visible         false
end
