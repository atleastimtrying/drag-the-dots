window.Layouts =
  random: ()->
    range = $('#container .dot').width()/2
    $('#container .dot').each (index, dot)=>
      $(dot).css
        top: Math.ceil(Math.random()* ($('#container').height() - (range * 2) - 90)) + 90
        left: Math.ceil(Math.random()* ($('#container').width() - (range * 2)))
        background: Colours.dot(index)
      $(dot).css({background: Colours.dot(1)}) if index is 0
      $('body').css 'background-color' : Colours.background(1)
  grid: ->
    count = $('#container .dot').length
    layouts = []
    edge = Math.floor(Math.sqrt(count)) - 1
    x = 0
    y = 0
    for i in [0..(count - 1)]
      layouts.push { x:x, y:y }
      if x < edge 
        x += 1
      else
        x = 0
        y += 1
    layouts = layouts.sort -> 0.5 - Math.random()
    difference = ((edge + 1) /2 * 60)
    center = { x: ($('#container').width() /2) + difference, y: ($('#container').height() /2) + difference }
    $('#container .dot').each (index, dot)=>
      coords = layouts[index]
      $(dot).css
        left: center.x - coords.x * 70 
        top: center.y - coords.y * 70
        background: Colours.dot(index)
      $(dot).css background: Colours.dot(1) if index is 0
      $('body').css 'background-color' : Colours.background(1)
  moving: ->
    change = ->
      range = $('.dot').width()/2
      $('.dot').each (index, dot) ->
        $(dot).css
          top: Math.ceil(Math.random()* ($('#container').height() - (range * 2) - 90)) + 90
          left: Math.ceil(Math.random()* ($('#container').width() - (range * 2)))
    unbindbody = (event, label)->
      $(window.app).off('collide', change) 
      $(window.app).off('show', unbindbody) 
    $(window.app).on 
      'collide': change
      'show': unbindbody
    $('#container .dot').addClass('moving')
    Layouts.random()
  movingplus: ->
    playing = true
    tick = ->
      $('#container .dot.movingplus').each (index, dot) ->
        unless $(dot).hasClass 'ui-draggable-dragging'
          speed = parseInt($(dot).data('value'))/3
          left = parseFloat($(dot).css('left')) + speed
          top = parseFloat($(dot).css('top')) + speed
          if left - 60 > $('#container').width()
            left = - 60
          if top - 60 > $('#container').height()
            top = - 60
          $(dot).css
            top: top
            left: left
      requestAnimationFrame(tick) if playing
    end = (event, label)->
      playing = false 
      $(window.app).off
        'show': end
    $(window.app).on
      'show': end
    $('#container .dot').addClass('movingplus')
    Layouts.random()
    tick()
  maze: ->
    Maze.layout()
    $('#container .dot').each (index, dot)=>
      if index % 2 is 0
        $(dot).css
          top: '112px'
          left: Math.ceil(Math.random()* ($('#container').width() - 60))
          background: Colours.dot(index)
      else
        $(dot).css
          bottom: '38px'
          left: Math.ceil(Math.random()* ($('#container').width() - 60))
          background: Colours.dot(index)
      $(dot).css background: Colours.dot(1) if index is 0
    $('#container .dot').addClass('outline')
    end = (event, label)->
      Maze.clear() 
      $(window.app).off
        'show': end
    $(window.app).on
      'show': end
  circle: ->
    count = $('#container .dot').size()
    angle = 360 / count
    radians = (degrees)-> degrees * (Math.PI/180)
    centerx = ($(window).width() / 2)
    centery = ($(window).height() / 2)
    radius = Math.min(centerx, centery) * 0.8
    layouts = []
    $('#container .dot').each (i, dot)=>
      x = centerx + Math.sin(radians(i*angle)) * radius
      y = centery + Math.cos(radians(i*angle)) * radius
      layouts.push
        top: "#{y}px"
        left: "#{x}px"
    layouts = layouts.sort -> 0.5 - Math.random()
    options = window.app.options.getOptions()
    bg = "white"
    bg = "transparent"  unless options.background
    $('#container .dot').each (i, dot)=>
      $(dot).css 
        top: layouts[i].top
        left: layouts[i].left
        background: bg
      $(dot).addClass('spinny')
    $('body').css 'background-color' : Colours.background(1)
  tiny: ->
    $('#container .dot').addClass('tiny')
    Layouts.grid()