$ ->
  con = $('#description')

  $('a.detail').live 'click', ->
    href = this.href
    con.fadeOut ->
      con.data('orig-content', con.html())
      con.load href, null, ->
        $('#detail').addClass('more')
        con.fadeIn ->
          back = $('<p class="link">[zurück]</p>')
          back.click ->
            con.scroller {reset: true}
            con.fadeOut ->
              $('#detail').removeClass('more')
              con.html con.data('orig-content')
              con.fadeIn()
            return false
          con.append(back)
          con.scroller {redetectHeight: true}
    return false

  $('.description').scroller()

  $('.ro').each ->
    pic = $(this)
    orig = this.src
    pic.data 'src',   orig
    pic.data 'src-a', orig.replace(/(.*)\.(.*)/, "$1-a.$2")
  .hover ->
    pic = $(this)
    pic.attr 'src', pic.data('src-a')
  , ->
    pic = $(this)
    pic.attr 'src', pic.data('src')

  preloads  = []
  voter     = null
  interval  = null

  $('#main').data('orig-src', $('#main').attr('src'))
  $("[data-image]").each( ->
    i = new Image()
    i.src = $(this).attr('data-image')
    preloads.push i
  ).mouseover( ->
    stopDiashow()
    vote $(this).attr('data-image'), false
  ).mouseout( ->
    startDiashow()
    vote $('#main').data('orig-src'), true
  )

  vote = (url, delayed = false, faded = false) ->
    clearTimeout(voter) if (voter)
    delay = if delayed then 400 else 0
    img   = $('#main')

    voter = setTimeout ->
      if faded
        img.fadeOut 200, -> img.attr('src', url).fadeIn(200)
      else
        img.attr('src', url)

      voter = null
    , delay

  startDiashow = ->
    if diashow?
      i = 0

      interval = setInterval ->
        i = (i + 1) % diashow.length
        vote diashow[i], false, true
      , 5000

  stopDiashow = ->
    clearInterval interval

  startDiashow()
