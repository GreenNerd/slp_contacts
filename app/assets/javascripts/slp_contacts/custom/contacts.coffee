$ ->
  testdata =
    contacts: [
      {
        name: '郑晶晶'
        phone: 15882890324
        favorited: false
      }
      {
        name: '张光'
        phone: 15278687812
        favorited: true
      }
      {
        name: '鲁臻'
        phone: 15872384724
      }
    ]

  ContactCtrl =
    init: ->
      @enableOrganizationSidebar()
      @setApiSettings()
      @initContactsView() if $('#contacts_list').length and $('#contacts_thumbnail_list').length
      @enableQueryUser() if $('#query_user').length
      @enableQueryOrganization() if $('#query_organization').length

    initContactsView: ->
      @contactsCollection = new SLPContacts.Collections.UserCollection testdata.contacts
      @createContactsShowView()
      @createContactsEditView()

      $('#query_organization').on 'click', '.view-toggler', (event)=>
        $(event.target).closest('.view-toggler').toggleClass('fa-th').toggleClass('fa-th-list')
        @toggleEditView()

    setApiSettings: ->
      apiSettings =
        api:
          'query user': 'users/{id}?name={query}'
          'query organization': 'organizations/{id}?name={query}'
      $.extend $.fn.api.settings, apiSettings

    enableOrganizationSidebar: ->
      organization_sidebar = $('#organization_list')
        .sidebar 'setting', 'onVisible', ->
          $('#toggle_sidebar').removeClass('fa-chevron-down').addClass('fa-chevron-up')
        .sidebar 'setting', 'onHidden', ->
          $('#toggle_sidebar').removeClass('fa-chevron-up').addClass('fa-chevron-down')
      $('#toggle_sidebar').click (event)->
        event.stopPropagation()
        if $(this).hasClass('fa-chevron-down')
          organization_sidebar.sidebar('show')
        else
          organization_sidebar.sidebar('hide')

    enableQueryUser: ->
      user_id = 1
      $sticker = $('#query_user')
      $query_trigger = $sticker.find('.ui.search')

      $sticker.on 'click', '.right-side i', ->
        $sticker.addClass('query-user')
      $query_trigger.search
        apiSettings:
          action: 'query user'
          urlData:
            id: user_id
          onError: (err_msg, element)->
            console.log err_msg
        onSelect: (result, response)->
          $sticker.removeClass('query-user')
        searchFullText: false

    enableQueryOrganization: ->
      organization_id = 1
      $sticker = $('#query_organization')
      $query_trigger = $sticker.find('.ui.search')

      $sticker.on 'click', '.title', ->
        $sticker.addClass('query-view')
      $query_trigger.search
        apiSettings:
          action: 'query organization'
          urlData:
            id: organization_id
          onError: (err_msg, element)->
            console.log err_msg
        onSelect: (result, response)->
          $sticker.removeClass('query-view')
        searchFullText: false

    createContactsShowView: ->
      @contactsShowView = new SLPContacts.Views.UsersShowView
        collection: @contactsCollection
        el: '#contacts_thumbnail_list'

    createContactsEditView: ->
      @contactsEditView = new SLPContacts.Views.UsersEditView
        collection: @contactsCollection
        el: '#contacts_list'

    toggleEditView: ->
      @contactsShowView.$el.toggle()
      @contactsEditView.$el.toggle()

  ContactCtrl.init()