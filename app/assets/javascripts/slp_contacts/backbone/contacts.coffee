class SLPContacts.Models.UserModel extends Backbone.Model
  defaults:
    name: ''
    identifier: ''
    phone: ''
    organizations: []
    tags: []
    favorited: false
    headimg: 'http://placehold.it/80x80'

class SLPContacts.Collections.UserCollection extends Backbone.Collection
  model: SLPContacts.Models.UserModel
  url: '/users'

SLPContacts.Templates.UserGridTemplate = """
  <div class="ui statistic">
    <div class="value">
      <img src="<%= headimg %>" alt="user_pic" class="ui circular centered image">
    </div>
    <div class="label"><%= name %></div>
  </div>
"""

SLPContacts.Templates.UserListTemplate = """
  <div class="right floated compact ui <%= favorited ? 'basic' : 'secondary' %> button"><%= favorited ? '取消' : '收藏' %></div>
  <img src="<%= headimg %>" alt="user_pic" class="ui avatar image">
  <div class="content">
    <div class="header"><%= name %></div>
    <div class="description"><%= phone %></div>
  </div>
"""

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



