json.contacts do
  json.array! @contacts do |contact|
    json.(contact, :id, :name, :phone)
    json.headimg contact.headimgurl
    json.favorited true
  end
end