Fabricator(:custom_field, class_name: 'SlpContacts::CustomField') do
  name            { sequence(:name) { |i| "Name-#{i}"  }  }
  field_type      "输入框"
  possible_values "MyString"
  is_required     false
  is_unique       false
  editable        false
  visible         false
end
