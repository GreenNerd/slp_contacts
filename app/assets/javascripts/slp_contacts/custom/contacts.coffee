$ ->
  ContactCtrl =
    init: ->
      @enableOrganizationSidebar()
      @setApiSettings()
      @enableQueryUser() if $('#query_user').length

    setApiSettings: ->
      apiSettings =
        api:
          'query user': 'users/{id}?name={query}'
          'query organization': '/organizations/{id}?name={query}'
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

  ContactCtrl.init()