json.contacts do
  json.array! @members do |member|
    json.(member, :id, :name, :phone)
    json.headimg member.headimgurl
    json.favorited current_user.favorited? member
  end
end