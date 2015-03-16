$ ->
  ContactCtrl =
    init: ->
      @setApiSettings()
      @enableSettingsSidebar() if $('#settings_view').length
      @enableOrganizationAccordion() if $('#organization_list').length
      @initContactsView() if $('#contacts_list').length
      @enableQueryUI() if $('#query_sticker').length

    initContactsView: ->
      @contactsCollection = new SLPContacts.Collections.UserCollection []
      if ///organizations///.test location.pathname
        @contactsCollection.url = "#{location.pathname}.json"
      else
        @contactsCollection.url = '/apps/contacts/user/favorites.json'
      contactViewType = localStorage.getItem('SLPContactViewType') or 'list'
      @createContactsView contactViewType
      @enableViewTab()
      @contactsCollection.listenToOnce @contactsCollection, 'reset', =>
        @enableLoadMore()

    setApiSettings: ->
      apiSettings =
        api:
          'query user': '/apps/contacts/users/query?name={query}'
          'query favorited user': '/apps/contacts/user/favorites/query?name={query}'
          'query organization member': '/apps/contacts/organizations/{id}/query?name={query}'
      $.extend $.fn.api.settings, apiSettings

    enableSettingsSidebar: ->
      $setting = $('#settings_view')
      $toggler = $('#toggle_sidebar')
      $content = $('#main_content')

      hideSetting = ->
        $setting.removeClass('active')
        $content.removeClass('dimmeded')

      showSetting = ->
        $setting.addClass('active')
        $content.addClass('dimmeded')

      $toggler.on 'click', (event)->
        event.stopPropagation()
        if $setting.hasClass('active')
          hideSetting()
        else
          showSetting()
          $(document).one 'click', ->
            hideSetting()

    enableViewTab: ->
      contactViewType = localStorage.getItem('SLPContactViewType') or 'list'
      $('#settings_view').find("[tab-target-type=#{contactViewType}]").addClass('active')

      $('#settings_view').on 'click', '.ui.button', (event)=>
        $this = $(event.target).closest('.ui.button')
        target_type = $this.attr('tab-target-type')
        unless $this.hasClass('active')
          $this.siblings('.active').removeClass('active')
          $this.addClass('active')

          @contactsView.reRender target_type
          localStorage.setItem 'SLPContactViewType', target_type

    enableOrganizationAccordion: ->
      $organization_list = $('#organization_list')

      openAccordion = ->
        $organization_list.accordion 'open', 0
      closeAccordion = ->
        $organization_list.accordion 'close', 0

      $title = $('#toggle_organizations')
      $title.on 'click', (event)->
        $icon = $title.find('i')
        if $icon.hasClass('fa-angle-down')
          openAccordion()
          $icon.removeClass('fa-angle-down').addClass('fa-angle-up')
        else
          closeAccordion()
          $icon.addClass('fa-angle-down').removeClass('fa-angle-up')

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
          user: (response)->
            _templates = response.results.map (user)->
              user.headimg ?= 'http://placehold.it/80x80'
              return """
                <a class="item" href="/apps/contacts/users/#{user.id}">
                  <img src="#{user.headimg}" alt="user_pic" class="ui avatar image">
                  <div class="content">
                    <div class="header">#{user.name}</div>
                    <div class="description">#{user.phone}</div>
                  </div>
                </a>
              """
            return _templates.join('')

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
        add: true
        merge: false
        success: (collection, response, jqxhr)=>
          SLPContacts.Cache.Contact_page = parseInt(jqxhr.xhr.getResponseHeader('X-Slp-Contacts-Current-Page'))
          new_data = @contactsCollection.add response
          @contactsView.append(new_data)
          if SLPContacts.Cache.Contact_page is parseInt(jqxhr.xhr.getResponseHeader('X-Slp-Contacts-Total-Page'))
            SLPContacts.Cache.Contact_maymore = false
            $('#load_more').closest('.sticky-footer').remove()
          else
            SLPContacts.Cache.Contact_maymore = true

  ContactCtrl.init()