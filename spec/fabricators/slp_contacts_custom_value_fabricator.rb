Fabricator(:custom_value, class_name: 'SlpContacts::CustomValue') do
  custom_field
  value           "MyString"
  user
end
