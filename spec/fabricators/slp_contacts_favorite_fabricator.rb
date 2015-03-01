Fabricator(:favorite, class_name: 'SlpContacts::Favorite') do
  user
  contact
end
