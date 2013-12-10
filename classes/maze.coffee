Maze = 
  layout: ->
    spacing = 92
    @clear()
    centery = $('#container').height()/2
    width = $('#container').width()
    left = Math.ceil Math.random() * width
    @addWall centery - spacing, -left, width
    @addWall centery - spacing, width - left + spacing, width
    left = Math.ceil Math.random() * width
    @addWall centery, -left, width
    @addWall centery, width - left + spacing, width
    left = Math.ceil Math.random() * width
    @addWall centery + spacing, -left, width
    @addWall centery + spacing, width - left + spacing, width
  clear: ->
    $('#container .wall').remove()

  addWall: (top, left, width)->
    $('#container').append("<div class='wall' style='top:#{top}px; left:#{left}px; width:#{width}px;'>")

  wallCollision: (dot)->
    $('.wall').each (index, wall)->
      if false
        dot_pos = $(dot).position()
        range = $('#container .dot').width()
        xs = dot_pos.left - item2.left
        xs = xs * xs
        ys = dot_pos.top - item2.top
        ys = ys * ys
        dist = Math.sqrt xs + ys
        (dist < range)