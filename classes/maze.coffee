window.Maze = 
  layout: (@app)->
    @clear()
    @layoutWalls()
    Maze.radius = $('.dot').width()/2
    Maze.wall_width = $('.wall').width() - 8
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

  addWall: (top, left, width, klass)->
    $('#container').append("<div class='wall #{klass}' style='top:#{top}px; left:#{left}px; width:#{width}px;'>")

  randomLeft: (width)->
    Math.ceil(Math.random() * (width - 92)) + 92
  
  moveWalls: ->
    spacing = 92
    centery = $('#container').height()/2
    width = $('#container').width()
    left = Maze.randomLeft(width)
    $('.wall').each (index, wall)->
      if index is 0
        $(wall).css
          left: -left
      if index is 1
        $(wall).css
          left: width - left + spacing 
        left = Maze.randomLeft(width)

      if index is 2
        $(wall).css
          left: -left

      if index is 3
        $(wall).css
          left: width - left + spacing
        left = Maze.randomLeft(width)

      if index is 4
        $(wall).css
          left: -left

      if index is 5
        $(wall).css
          left: width - left + spacing
    


  verticalRange: (y, top, range)->
    y > top - range + 8 and y < top + range

  horizontalRange: (x, left, width)->
    x > left + 4 and x < left + width + 4
  
  leftEndHit: (x,y,top_left, range)->
    ys = y - (top_left.top + 4)
    ys = ys * ys
    xs = x - (top_left.left + 4)
    xs = xs * xs
    Math.sqrt(ys + xs) < range

  rightEndHit: (x, y, top_left, width, range)->
    ys = y - (top_left.top + 4)
    ys = ys * ys
    xs = x - (top_left.left + width + 4)
    xs = xs * xs
    Math.sqrt(ys + xs) < range

  hitDetection: (dot_position)->
    x = dot_position.left
    y = dot_position.top
    radius = Maze.radius
    width = Maze.wall_width
    range = radius + 4
    hit = false
    $('.wall').each (index, wall)->
      top_left = $(wall).position()
      if Maze.verticalRange(y, top_left.top, range + 4)
        hit = true if Maze.horizontalRange(x, top_left.left, width) or Maze.rightEndHit(x, y, top_left, width, range) or Maze.leftEndHit(x,y,top_left, range)
    hit

  layoutWalls: ->
    spacing = 92
    centery = $('#container').height()/2
    width = $('#container').width()
    left = Maze.randomLeft(width)
    @addWall centery - spacing, -left, width, 'left'
    @addWall centery - spacing, width - left + spacing, width, 'right'
    left = Maze.randomLeft(width)
    @addWall centery, -left, width, 'left'
    @addWall centery, width - left + spacing, width, 'right'
    left = Maze.randomLeft(width)
    @addWall centery + spacing, -left, width, 'left'
    @addWall centery + spacing, width - left + spacing, width, 'right'