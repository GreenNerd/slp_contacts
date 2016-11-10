json.(user, :id, :name)
if current_user.can_detail_contact?(user)
  json.phone user.phone
end

json.headimgurl user.headimgurl_with_size(:small)
json.favorited current_user.favorited? user

