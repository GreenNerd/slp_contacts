class SLPContacts.Views.UserView extends Backbone.View
  tagName: 'div'

  renderGrid: ->
    @$el.addClass('column')
    @$el.html _.template(SLPContacts.Templates.UserGridTemplate)(@model.toJSON())

  renderList: ->
    @$el.addClass('item')
    @$el.html _.template(SLPContacts.Templates.UserListTemplate)(@model.toJSON())


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

