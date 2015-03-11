class SLPContacts.Views.UserView extends Backbone.View
  tagName: 'div'
  events:
    'click .compact': 'toggleFavorite'

  render: (type)->
    switch type
      when 'list'
        @renderList()
      else
        @renderGrid()

  renderGrid: ->
    @$el.addClass('ui column center aligned')
    @$el.html _.template(SLPContacts.Templates.UserGridTemplate)(@model.toJSON())

  renderList: ->
    @$el.addClass('item')
    @$el.html _.template(SLPContacts.Templates.UserListTemplate)(@model.toJSON())

  toggleFavorite: (event)->
    event.preventDefault()
    $favorite = @$('.compact')
    @model.toggleFavorite ()=>
      if @model.get 'favorited'
        $favorite.removeClass('secondary').addClass('basic').text('取消')
      else
        $favorite.removeClass('basic').addClass('secondary').text('收藏')


class SLPContacts.Views.UsersView extends Backbone.View
  initialize: (options)->
    @type = options.type
    @render()

  render: ->
    @$el.removeClass().html ''
    switch @type
      when 'list'
        @$el.addClass 'ui celled very relaxed list'
      else
        @$el.addClass 'ui three column padded grid'
    _.each @collection.models, (model)=>
      @renderItem(model)

  reRender: (type)->
    @type = type
    @render()

  renderItem: (user)->
    user_view = new SLPContacts.Views.UserView
      model: user
      CollectionView: @
    user_view.render @type
    @$el.append user_view.$el

  append: (models)->
    _.each models, (model)=>
      @renderItem(model)
