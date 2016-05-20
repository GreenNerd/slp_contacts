class SLPContacts.Models.UserModel extends Backbone.Model
  defaults:
    name: ''
    identifier: ''
    phone: ''
    organizations: []
    tags: []
    favorited: false
    headimgurl: 'http://placehold.it/80x80'

  initialize: ->
    @baseurl = "#{SLPContacts.Settings.prefix_link}/users/#{@id}"

  toggleFavorite: (success)->
    if @get('favorited')
      @unFavorite(success)
    else
      @favorite(success)

  unFavorite: (success)->
    @url = @baseurl + "/unfavorite.json"
    @sync('delete', @, {
      success: =>
        @set 'favorited', not @get('favorited')
        success()
      error: ->
        console.log 'fail to unfavorite'
    })

  favorite: (success)->
    @url = @baseurl + "/favorite.json"
    @sync('create', @, {
      success: =>
        @set 'favorited', not @get('favorited')
        success()
      error: ->
        console.log 'fail to unfavorite'
    })
