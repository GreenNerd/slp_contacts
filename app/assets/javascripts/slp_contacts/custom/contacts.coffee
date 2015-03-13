$ ->
  ContactCtrl =
    init: ->
      @setApiSettings()
      @enableOrganizationAccordion() if $('#organization_list').length
      @enableSettingsSidebar() if $('#settings_sidebar').length
      @initContactsView() if $('#contacts_list').length
      @enableQueryUI() if $('#query_sticker').length

    initContactsView: ->
      @contactsCollection = new SLPContacts.Collections.UserCollection []
      if ///organizations///.test location.pathname
        @contactsCollection.url = "#{location.pathname}/members.json"
      else
        @contactsCollection.url = '/apps/contacts/favorites.json'
      contactViewType = localStorage.getItem('SLPContactViewType') or 'list'
      @createContactsView contactViewType
      @enableViewTab()
      @contactsCollection.listenToOnce @contactsCollection, 'reset', =>
        @enableLoadMore()

    setApiSettings: ->
      apiSettings =
        api:
          'query user': '/apps/contacts/query?name={query}'
          'query favorited user': '/apps/contacts/favorites/query?name={query}'
          'query organization member': '/apps/contacts/organizations/{id}/query?name={query}'
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
        searchFields: ['name', 'title']
        type: 'user'
        searchDelay: 600
        templates:
          user: (user)->
            user.headimg ?= 'http://placehold.it/80x80'
            return """
              <a class="item" href="/apps/contacts/users/#{user.id}">
                <img src="#{user.headimg}" alt="user_pic" class="ui avatar image">
                <div class="content">
                  <a href="##" class="header">#{user.name}</a>
                  <div class="description">#{user.phone}</div>
                </div>
              </a>
            """

    createContactsView: (type)->
      @contactsCollection.fetch
        reset: true
        success: (collection, response)=>
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
        data:
          page: page
        remove: false
        reset: false
        add: false
        merge: false
        success: (collection, response)=>
          SLPContacts.Cache.Contact_page += 1
          new_data = @contactsCollection.add response
          @contactsView.append(new_data)
          if response.length < SLPContacts.Settings.per_page
            SLPContacts.Cache.Contact_maymore = false
            $('#load_more').closest('.sticky-footer').remove()
          else
            SLPContacts.Cache.Contact_maymore = true

  ContactCtrl.init()