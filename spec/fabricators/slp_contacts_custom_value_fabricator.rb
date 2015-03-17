Fabricator(:custom_value, class_name: 'SlpContacts::CustomField') do
  custom_field
  value           "MyString"
  user
end
