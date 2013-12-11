window.Maze = 
  layout: ->
    spacing = 92
    Maze.radius = $('.dot').width()/2
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
    $('#container .dot').on 'drag', (event)->
      Maze.tick(event)
    Maze.lastpos = {top: 0, left: 0}

  tick: (event)=>
    if $('#container .dot.ui-draggable-dragging')[0]
      position = $('#container .dot.ui-draggable-dragging').position()
      if Maze.hitDetection(position)
        event.preventDefault()
        $('#container .dot.ui-draggable-dragging').css 
          top: Maze.lastpos.top
          left: Maze.lastpos.left
      else
        Maze.lastpos = position

  clear: ->
    $('#container .wall').remove()

  addWall: (top, left, width)->
    $('#container').append("<div class='wall' style='top:#{top}px; left:#{left}px; width:#{width}px;'>")

  hitDetection: (dot_position)->
    x = dot_position.left
    y = dot_position.top
    radius = Maze.radius
    hit = false
    $('.wall').each (index, wall)->
      top_left = $(wall).position()
      width = $(wall).width() - 8
      range = radius + 4

      ys = y - (top_left.top + 4)
      ys = ys * ys
      xs = x - (top_left.left + 4)
      xs = xs * xs
      distance_between_dot_and_left_end = Math.sqrt ys + xs
      
      ys = y - (top_left.top + 4)
      ys = ys * ys
      xs = x - (top_left.left + width + 4)
      xs = xs * xs
      distance_between_dot_and_right_end = Math.sqrt ys + xs

      hit = true if distance_between_dot_and_right_end < range or distance_between_dot_and_left_end < range or (y > top_left.top - radius and y < top_left.top + range + 4 and x > top_left.left + 4 and x < top_left.left + width + 4)
    hit