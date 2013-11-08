window.Layouts =
  random: ()->
    range = $('#container .dot').width()/2
    $('#container .dot').each (index, dot)=>
      $(dot).css
        top: Math.ceil(Math.random()* ($('#container').height() - (range * 2)))
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
    difference = (edge + 1) /2 * 60
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
          top: Math.ceil(Math.random()* ($('#container').height() - (range * 2)))
          left: Math.ceil(Math.random()* ($('#container').width() - (range * 2)))
    unbindbody = (event, label)->
      $('body').off('collide', change) 
      $('body').off('show', unbindbody) 
    $('body').on 
      'collide': change
      'show': unbindbody
    $('#container .dot').addClass('moving')
    Layouts.random()
  circle: ->
    count = $('#container .dot').size()
    angle = 360 / count
    radians = (degrees)-> degrees * (Math.PI/180)
    centerx = $('#container').width() / 2
    centery = $('#container').height() / 2
    radius = Math.min(centerx, centery) * 0.8
    layouts = []
    $('#container .dot').each (i, dot)=>
      x = centerx + Math.sin(radians(i*angle)) * radius
      y = centery + Math.cos(radians(i*angle)) * radius
      layouts.push
        top: "#{y}px"
        left: "#{x}px"
    $('body').css
      'background-color':'#333'
    layouts = layouts.sort -> 0.5 - Math.random()
    $('#container .dot').each (i, dot)=>
      $(dot).css layouts[i]
      $(dot).addClass 'spinny'
  tiny: ->
    $('.dot').addClass('tiny')
    Layouts.grid()