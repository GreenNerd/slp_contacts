$ ->
  $doc = $(document)
  if ///mobile///.test navigator.userAgent.toLowerCase()
    ontouchstart = (event)->
      touchesList = event.originalEvent.targetTouches
      # 如果是多点触控或没有触点，则直接返回
      return true if touchesList.length isnt 1

      touchStartEvent = touchesList[0]
      # 记录start的信息
      touch_details =
        start_screen_Y: touchStartEvent.screenY
        start_page_Y: touchStartEvent.pageY
        start_client_Y: touchStartEvent.clientY
        moved: false
        start_scrollTop: $doc.scrollTop()

      ontouchmove = (event)->
        touchMoveEvent = event.originalEvent.targetTouches[0]
        deltaY = touchMoveEvent.screenY - touch_details.start_screen_Y
        touch_details.moved = true
        touch_details.deltaY = Math.abs deltaY
        if deltaY > 0
          $doc.trigger 'swipe.down', {details: touch_details}
        else if deltaY < 0
          $doc.trigger 'swipe.up', {details: touch_details}
        else
          $doc.trigger 'swipe.none', {details: touch_details}

      ontouchend = (event)->
        $doc.off 'touchmove', ontouchmove

        touchEndEvent = event.originalEvent.changedTouches[0]
        deltaY = touchEndEvent.screenY - touch_details.start_screen_Y
        touch_details.moved = false
        touch_details.deltaY = Math.abs deltaY

        if deltaY > 0
          $doc.trigger 'swiped.down', {details: touch_details}
        else if deltaY < 0
          $doc.trigger 'swiped.up', {details: touch_details}
        else
          $doc.trigger 'swiped.none', {details: touch_details}

        $doc.off 'touchend', ontouchend
        $doc.on 'touchstart', ontouchstart

      $doc.on 'touchmove', ontouchmove
      $doc.on 'touchend', ontouchend
      $doc.off 'touchstart', ontouchstart

    # 给document上的touchmove事件绑定处理程序。
    $doc.on 'touchstart', ontouchstart

    checkPullTop = (event, data)->
      if $doc.scrollTop() is 0
        $doc.one 'swipe.down', ->
          $doc.trigger 'pullTop'
        $doc.one 'swipe.up', checkUpScroll

    checkUpScroll = (event, data)->
      if $doc.scrollTop() is 0
        $doc.one 'swipe.up', ->
          $doc.trigger 'upScroll'
        $doc.one 'swipe.down', checkPullTop

    $doc.one 'swipe.down', checkPullTop

    $doc.one 'swipe.up', checkUpScroll

  else
    $(window).on 'scroll', (event)->
      if $doc.scrollTop() < 0
        setTimeout ->
          $doc.trigger 'pullTop'
        , 100
      else if $doc.scrollTop() > 0
        setTimeout ->
          $doc.trigger 'upScroll'
        , 100