json.contacts do
  json.array! @members do |member|
    json.(member, :id, :name, :phone)
    json.headimg member.headimgurl
    if current_user.favorited?(member)
      json.favorited 'true'
    else
      json.favorited 'false'
    end
  end
end