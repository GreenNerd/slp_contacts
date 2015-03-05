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
    contacts2: [
      {
        name: '砍了就跑'
        phone: 18677274273
        favorited: true
      }
      {
        name: '呆瓜'
        phone: 17328983439
        favorited: true
      }
    ]

  ContactCtrl =
    init: ->
      @enableOrganizationAccordion()
      @enableSettingsSidebar() if $('#settings_sidebar').length
      @setApiSettings()
      if $('#contacts_list').length and $('#contacts_thumbnail_list').length
        @enableViewTab()
        @initContactsView()
      @enableQueryUser() if $('#query_user').length
      @enableQueryOrganization() if $('#query_organization').length

    initContactsView: ->
      @$activedView = $('#contacts_thumbnail_list')
      @contactsCollection = new SLPContacts.Collections.UserCollection testdata.contacts
      @createContactsGridView()
      @createContactsListView()
      @enableLoadMore()

    setApiSettings: ->
      apiSettings =
        api:
          'query user': 'users/{id}?name={query}'
          'query organization': 'organizations/{id}?name={query}'
      $.extend $.fn.api.settings, apiSettings

    enableSettingsSidebar: ->
      $sidebar = $('#settings_sidebar')
      $toggler = $('#toggle_sidebar')
      $sidebar
        .sidebar 'setting', 'transition', 'overlay'
        .sidebar 'setting', 'onVisible', ->
          $toggler.one 'click', ->
            $sidebar.sidebar('hide')
        .sidebar 'setting', 'onHidden', ->
          $toggler.one 'click', ->
            $sidebar.sidebar('show')

      $toggler.one 'click', (event)->
        event.stopPropagation()
        $sidebar.sidebar('show')

    enableViewTab: ->
      $('#settings_sidebar').on 'click', '.ui.button', (event)=>
        @$activedView.hide()
        $this = $(event.target).closest('.ui.button')
        $target = $ $this.attr('tab-target')
        unless $this.hasClass('active')
          $target.show()
          @$activedView = $target
          $this.siblings('.active').removeClass('active')
          $this.addClass('active')
        $('#settings_sidebar').sidebar('hide')

    enableOrganizationAccordion: ->
      $organization_list = $('#organization_list')
      trigger_pull = false

      openAccordion = ->
        $organization_list.accordion 'open', 0
      closeAccordion = ->
        $organization_list.accordion 'close', 0

      $(document).on 'pullTop', ->
        openAccordion()

      $organization_list.accordion 'setting', 'onOpen', ->
        $(document).on 'upScroll', ->
          closeAccordion()

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

    createContactsGridView: ->
      @contactsGridView = new SLPContacts.Views.UsersGridView
        collection: @contactsCollection
        el: '#contacts_thumbnail_list'

    createContactsListView: ->
      @contactsListView = new SLPContacts.Views.UsersListView
        collection: @contactsCollection
        el: '#contacts_list'

    enableLoadMore: ->
      $loadMoreCtrl = $('#load_more')
      SLPContacts.Cache.Contact_page ?= 1
      SLPContacts.Cache.Contact_maymore = if @contactsCollection.length >= SLPContacts.Settings.per_page then true else false
      if SLPContacts.Cache.Contact_maymore
        $loadMoreCtrl.text('加载更多')
      else
        $loadMoreCtrl.text('已经加载完啦!')
      $loadMoreCtrl.on 'click', (event)=>
        event.stopPropagation()
        @loadMoreContacts SLPContacts.Cache.Contact_page + 1 if SLPContacts.Cache.Contact_maymore

    loadMoreContacts: (page)->
      @contactsCollection.fetch
        page: page
      , (response)=>
        SLPContacts.Cache.Contact_page += 1
        new_data = @contactsCollection.add(response)
        @contactsListView.append(new_data)
        @contactsGridView.append(new_data)
        if response.length < SLPContacts.Settings.per_page
          SLPContacts.Cache.Contact_maymore = false
          $('#load_more').text('已经加载完啦!')
        else
          SLPContacts.Cache.Contact_maymore = true

  ContactCtrl.init()