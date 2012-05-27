(($) ->

  $.fn.scrollHeight = (redetect = false) ->
    el = $(this)
    if !redetect && (height = el.data('scrollHeight'))
      return height
    else
      h1 = el.height()
      el.css {'position': 'absolute', 'height': 'auto'}
      h2 = el.height()
      el.css {'position': '', 'height': h1}
      height = h2 - h1
      el.data 'scrollHeight', height
      return height

  $.fn.scroller = (settings) ->

    config = {
      autoScroll:     true
      redetectHeight: false
      reset:          false
    }
    $.extend config, settings if settings

    mouseY          = 0
    startPosition   = 0
    scrolling       = false

    return this.each ->
      el = $(this)

      scrollHeight = el.scrollHeight(true) unless config.reset

      if scrollHeight <= 0 || config.reset
        el.stop             true
        el.unbind           'mousedown'
        $(document).unbind  'mouseup'
        $(document).unbind  'mousemove'
        el.removeClass      'scrollable'
        scrolling = false
        return
      else
        if el.mousewheel?
          el.mousewheel (ev, offset) ->
            if restarter = el.data 'restarter'
              clearTimeout restarter

            el.css({opacity: 1.0}).stop(true)
            el.scrollTop(Math.ceil(el.scrollTop() - offset * 10))
            el.data 'restarter', setTimeout ->
              el.autoScroll false
            , 1000

        $(document).mousemove (e) ->
          mouseY = parseInt e.pageY, 0
          if scrolling
            scrolling.scrollTop startPosition - mouseY
            false

        # FIXME make this general
        el.css({"MozUserSelect": "none"})
          .bind("mousedown.disableTextSelect selectstart.disableTextSelect", -> false)

        el.mousedown ->
          el.css({opacity: 1.0}).stop(true)
          scrolling       = el
          startPosition   = mouseY + el.scrollTop()
          false

        $(document).mouseup ->
          if scrolling
            scrolling.autoScroll(false)
            scrolling = false
            false

        if config.autoScroll
          el.autoScroll = (resetPosition = true, redetectHeight = false) -> 
            el.resetPosition = ->
              $(this).scrollTop 0
            scrollHeight  = el.scrollHeight(redetectHeight)
            el.resetPosition() if resetPosition
            toScroll = scrollHeight - el.scrollTop()
            if (toScroll > 0) || !resetPosition
              el.addClass 'scrollable'
              el.delay(3000).animate {scrollTop: scrollHeight}, 60 * toScroll, 'linear', ->
                el.delay(2000).fadeOut ->
                  el.scrollTop 0
                  el.fadeIn ->
                    el.autoScroll()

          el.autoScroll(true, config.redetectHeight)


      return this
)(jQuery)
