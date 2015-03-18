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
    @baseurl = "/apps/contacts/users/#{@id}"

  toggleFavorite: (success)->
    if @get('favorited')
      @unFavorite(success)
    else
      @favorite(success)

  unFavorite: (success)->
    @url = @baseurl + "/unfavorite"
    _success = ()=>
      @set 'favorited', not @get('favorited')
      success()
    $.ajax
      url: @url
      type: 'delete'
      success: _success
      error: ->
        console.log 'fail to unfavorite!'

  favorite: (success)->
    @url = @baseurl + "/favorite"
    _success = ()=>
      @set 'favorited', not @get('favorited')
      success()
    $.ajax
      url: @url
      type: 'post'
      success: _success
      error: ->
        console.log 'fail to favorite!'