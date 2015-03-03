$ ->
  ContactCtrl =
    init: ->
      @enableOrganizationSidebar()

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

  ContactCtrl.init()