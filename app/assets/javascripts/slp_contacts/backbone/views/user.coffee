class SLPContacts.Views.UserView extends Backbone.View
  tagName: 'div'
  events:
    'click .compact': 'toggleFavorite'

  renderGrid: ->
    @$el.addClass('ui column center aligned')
    @$el.html _.template(SLPContacts.Templates.UserGridTemplate)(@model.toJSON())

  renderList: ->
    @$el.addClass('item')
    @$el.html _.template(SLPContacts.Templates.UserListTemplate)(@model.toJSON())

  toggleFavorite: ->
    $favorite = @$('.compact')
    @model.toggleFavorite ()=>
      if @model.favorited
        $favorite.removeClass('secondary').addClass('basic').text('取消')
      else
        $favorite.removeClass('basic').addClass('secondary').text('收藏')


class SLPContacts.Views.UsersView extends Backbone.View
  initialize: (options)->
    @render()

  render: ->
    @$el.html ''
    _.each @collection.models, (model)=>
      @renderItem(model)

  renderItem: (user)->
    user_view = new SLPContacts.Views.UserView
      model: user
      CollectionView: @
    @$el.append user_view.$el

  append: (models)->
    _.each models, (model)=>
      @renderItem(model)

class SLPContacts.Views.UsersGridView extends SLPContacts.Views.UsersView
  renderItem: (user)->
    user_view = new SLPContacts.Views.UserView
      model: user
      CollectionView: @
    user_view.renderGrid()
    @$el.append user_view.$el

class SLPContacts.Views.UsersListView extends SLPContacts.Views.UsersView
  renderItem: (user)->
    user_view = new SLPContacts.Views.UserView
      model: user
      CollectionView: @
    user_view.renderList()
    @$el.append user_view.$el

