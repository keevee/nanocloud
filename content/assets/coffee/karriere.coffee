$ ->
  req = $.get '/karriere.txt', (text) ->
    regexp = /<h1>(.*?)<\/h1>\s*?<h2>(.*?)<\/h2>([\s\S]*?<\/div>)/gi

    links = []
    pars  = []
    index = 0

    while m = regexp.exec text
      a = $('<a>').attr('href', '#anchor'+index).html(m[1])
      p = $(m[0])

      a.data('p', p)

      a.click ->
        $('.description').scroller {reset: true}
        $('#placeholder2').html($(this).data('p'))
        $('.description').scroller {redetectHeight: true}


      links.push a

      pars.push p
      index++

    $.each links, (idx, link) ->
      $('#placeholder').append $("<p/>").append(link)
