json.(user, :id, :name, :phone, :identifier)
json.headimgurl user.headimgurl_with_size(:small)
json.favorited current_user.favorited? user

