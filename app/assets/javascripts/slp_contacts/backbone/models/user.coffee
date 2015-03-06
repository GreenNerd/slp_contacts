class SLPContacts.Models.UserModel extends Backbone.Model
  defaults:
    name: ''
    identifier: ''
    phone: ''
    organizations: []
    tags: []
    favorited: false
    headimg: 'http://placehold.it/80x80'

  initialize: ->
    @url = @collection.url + "/#{@get('id')}"

  toggleFavorite: (success)->
    if @get('favorited')
      @unFavorite(success)
    else
      @favorite(success)

  unFavorite: (success)->
    @sync('delete', @).success(success).error ->
      console.log 'fail to unfavorite!'

  favorite: (success)->
    @sync('patch', @).success(success).error ->
      console.log 'fail to favorite'
