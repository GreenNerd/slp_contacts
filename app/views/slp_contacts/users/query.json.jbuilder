json.results do
  json.array! @result do |contact|
    json.(contact, :id, :name, :phone, :identifier)
    json.headimg contact.headimgurl
  end
end