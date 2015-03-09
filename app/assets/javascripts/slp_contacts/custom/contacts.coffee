$ ->
  testdata =
    contacts: [
      {
        name: '郑晶晶'
        id: 2
        phone: 15882890324
        favorited: false
      }
      {
        name: '张光'
        id: 3
        phone: 15278687812
        favorited: true
      }
      {
        name: '鲁臻'
        id: 4
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
      @setApiSettings()
      @enableOrganizationAccordion() if $('#organization_list').length
      @enableSettingsSidebar() if $('#settings_sidebar').length
      @initContactsView() if $('#contacts_list').length
      @enableQueryUI() if $('#query_sticker').length

    initContactsView: ->
      contactViewType = localStorage.getItem('SLPContactViewType') or 'list'
      @contactsCollection = new SLPContacts.Collections.UserCollection testdata.contacts
      @createContactsView contactViewType
      @enableViewTab()
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
      contactViewType = localStorage.getItem('SLPContactViewType') or 'list'
      $('#settings_sidebar').find("[tab-target-type=#{contactViewType}]").addClass('active')

      $('#settings_sidebar').on 'click', '.ui.button', (event)=>
        $this = $(event.target).closest('.ui.button')
        target_type = $this.attr('tab-target-type')
        unless $this.hasClass('active')
          $this.siblings('.active').removeClass('active')
          $this.addClass('active')

          @contactsView.reRender target_type
          localStorage.setItem 'SLPContactViewType', target_type
        $('#settings_sidebar').sidebar('hide')

    enableOrganizationAccordion: ->
      $organization_list = $('#organization_list')

      openAccordion = ->
        $organization_list.accordion 'open', 0
      closeAccordion = ->
        $organization_list.accordion 'close', 0

      $(document).on 'pullTop', ->
        openAccordion()

      $organization_list.accordion 'setting', 'onOpen', ->
        $(document).on 'upScroll', ->
          closeAccordion()

    enableQueryUI: ->
      $sticker = $('#query_sticker')
      $query_trigger = $sticker.find('.ui.search')
      query_data = $sticker.data()

      $sticker
        .on 'click', '.open-query', ->
          $sticker.addClass('query-view')
          $sticker.find('.query-input').focus()
        .on 'click', '.close-query', ->
          $sticker.removeClass('query-view')

      $query_trigger.search
        apiSettings:
          action: query_data.queryaction
          urlData:
            id: parseInt query_data.urlid
          onError: (err_msg, element)->
            console.log err_msg
        onSelect: (result, response)->
          $sticker.removeClass('query-view')
        searchFullText: false

    createContactsView: (type)->
      @contactsView = new SLPContacts.Views.UsersView
        collection: @contactsCollection
        el: '#contacts_list'
        type: type

    enableLoadMore: ->
      $loadMoreCtrl = $('#load_more')
      SLPContacts.Cache.Contact_page ?= 1
      SLPContacts.Cache.Contact_maymore = if @contactsCollection.length >= SLPContacts.Settings.per_page then true else false
      if SLPContacts.Cache.Contact_maymore
        $loadMoreCtrl.text('加载更多')
      else
        $loadMoreCtrl.closest('.sticky-footer').remove()
      $loadMoreCtrl.on 'click', (event)=>
        event.stopPropagation()
        @loadMoreContacts SLPContacts.Cache.Contact_page + 1 if SLPContacts.Cache.Contact_maymore

    loadMoreContacts: (page)->
      @contactsCollection.fetch
        page: page
      , (response)=>
        SLPContacts.Cache.Contact_page += 1
        new_data = @contactsCollection.add(response)
        @contactsView.append(new_data)

        if response.length < SLPContacts.Settings.per_page
          SLPContacts.Cache.Contact_maymore = false
          $('#load_more').text('已经加载完啦!')
        else
          SLPContacts.Cache.Contact_maymore = true

  ContactCtrl.init()