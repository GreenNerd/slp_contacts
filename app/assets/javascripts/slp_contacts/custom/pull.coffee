$ ->
  $doc = $(document)

  ontouchstart = (event)->
    event.stopPropagation()
    touchStartEvent = event.originalEvent.targetTouches[0]
    touch_details =
      startY: touchStartEvent.pageY
      startTop: $doc.scrollTop()
      moved: false

    $title = $('.sticky-header .title')

    ontouchmove = (event)->
      event.stopPropagation()
      touch_details.moved = true

    ontouchend = (event)->
      event.stopPropagation()
      touchEndEvent = event.originalEvent.changedTouches[0]
      touch_details.endY = touchEndEvent.pageY
      touch_details.endTop = $doc.scrollTop()
      if touch_details.moved
        if touch_details.endY > touch_details.startY and touch_details.startTop is 0
          $doc.trigger 'pullTop'
        else if touch_details.endY < touch_details.startY and (touch_details.startTop + window.screen.availHeight) is $doc.outerHeight()
          $doc.trigger 'pullBottom'
        else
          $doc.trigger 'pullNone'

        if touch_details.endY > touch_details.startY
          $doc.trigger 'lowerScroll'
        else if touch_details.endY < touch_details.startY
          $doc.trigger 'upScroll'
        else
          $doc.trigger 'noneScroll'

      $doc.off 'touchend', ontouchend
      $doc.off 'touchmove', ontouchmove
      touch_details = {}

    $doc.on 'touchmove', ontouchmove
    $doc.on 'touchend', ontouchend


  if ///mobile///.test navigator.userAgent.toLowerCase()
    $doc.on 'touchstart', ontouchstart
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