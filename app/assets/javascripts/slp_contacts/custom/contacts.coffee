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

    setApiSettings: ->
      @apiSettings =
        'query user': '/apps/contacts/users/query'
        'query favorited user': '/apps/contacts/user/favorites/query'
        'query organization member': '/apps/contacts/organizations/{id}/query'

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
      $query_input = $sticker.find('input')
      $results = $sticker.find('.results')
      query_data = $sticker.data()
      query_url = @apiSettings[query_data.queryaction].replace ///{id}///g, query_data.urlid

      $sticker
        .on 'click', '.open-query', ->
          $sticker.addClass('query-view')
          $query_input.focus()
        .on 'click', '.close-query', ->
          $sticker.removeClass('query-view')
          $query_input.val('')
        .on 'click', '.load-more', =>
          @queryWithPage query_url, $query_input.val(), SLPContacts.Cache.CurrentQueryPage + 1, true

      $query_input
        .on 'focus', =>
          if $query_input.val().trim().length
            $query_input.trigger 'start_query'
          else
            @hideQueryResults $results
        .on 'keydown', (event)=>
          clearTimeout @timer if @timer?
          @timer = setTimeout ->
            $query_input.trigger 'start_query'
            clearTimeout @timer
          , 600
          if event.keyCode is 13 and $query_input.val().length
            $query_input.trigger 'start_query'
            clearTimeout @timer
        .on 'start_query', =>
          query_word = $query_input.val()
          @queryWithPage query_url, query_word, 1, false

    queryWithPage: (url, term, page, concat=false)->
      $_results = $('#query_sticker').find('.results')
      if term.trim().length
        $.ajax
          type: 'get'
          url: url
          data:
            name: term
            page: page ?= 1
          dataType: 'json'
          success: (response, status, jqxhr)=>
            @displayQueryResults(response.results, $_results, term, concat)
            SLPContacts.Cache.CurrentQueryPage = parseInt jqxhr.getResponseHeader('X-Slp-Contacts-Current-Page')
            if SLPContacts.Cache.CurrentQueryPage < parseInt jqxhr.getResponseHeader('X-Slp-Contacts-Total-Page')
              $_results.append """
                <div class="load-more">加载更多</div>
              """
            else
              $_results.find('.load-more').remove()
      else
        @hideQueryResults $_results

    displayQueryResults: (results, $element, query_word, concat=false)->
      if results.length
        $element.find('.with-empty-item').remove()
        $element.find('.load-more').remove()
        _templates = _.map results, (user)->
          user.headimg ?= 'http://placehold.it/80x80'
          return """
            <a href="/apps/contacts/users/#{user.id}" class="item">
              <img src="#{user.headimg}" alt="user_pic" class="ui avatar image">
              <div class="content aligned">
                <div class="header">#{user.name}</div>
                <div class="description">#{user.phone}</div>
              </div>
            </a>
          """
        if concat
          $element.append _templates.join('')
        else
          $element.html _templates.join('')
      else
        $element.html """
          <div class="with-empty-item">
            找不到与"#{query_word}"相关的联系人
            <br>
            请重新输入...
          </div>
        """
      unless $element.hasClass('visible')
        $element.transition
          animation: 'fade in'
          duration: 300
          queue: true

    hideQueryResults: ($element)->
      if $element.hasClass('visible')
        $element.transition
          animation: 'fade out'
          duration: 300
          queue: true

    createContactsView: (type)->
      @contactsCollection.fetch
        reset: true
        data:
          page: 1
          per_page: SLPContacts.Settings.per_page
        success: (collection, response, jqxhr)=>
          @contactsView = new SLPContacts.Views.UsersView
            collection: @contactsCollection
            el: '#contacts_list'
            type: type
          SLPContacts.Cache.Contact_total_page = parseInt jqxhr.xhr.getResponseHeader('X-Slp-Contacts-Total-Page')
          @enableLoadMore()

    enableLoadMore: ->
      $loadMoreCtrl = $('#load_more')
      SLPContacts.Cache.Contact_page ?= 1
      SLPContacts.Cache.Contact_maymore = SLPContacts.Cache.Contact_total_page > 1
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
          per_page: SLPContacts.Settings.per_page
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