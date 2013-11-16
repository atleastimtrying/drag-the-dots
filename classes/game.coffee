class window.Game 
  constructor: (@app)->
    $('body').on('startGame', @startGame)
    @count = 10
    @timer = new Timer(@app)

  name: =>
    count = @count
    $(".table#{count}").prev('h3').text()

  startGame: (event, options = {count: @count, layout: @layout})=>
    @count = options.count if options.count
    @layout = options.layout if options.layout
    $('body').trigger 'show', 'game'
    $('#container .dot').remove()
    @addDots()
    @makeDotsDraggable()
    @layoutDots()
    @timer.start()
  
  collide: (item1, item2)->
    xs = item1.left - item2.left
    xs = xs * xs
    ys = item1.top - item2.top
    ys = ys * ys
    range = $('#container .dot').width()
    dist = Math.sqrt xs + ys
    (dist < range)
  
  hitDetection: (event)=>
    dot = $ event.target
    dotid = dot.attr('data-id')
    dot_value = dot.attr('data-value')
    target = $("[data-value=#{dot_value}]").not("[data-id=#{dotid}]")
    if target[0] and @collide(dot.offset(), target.offset())
      $('body').trigger 'collide'
      newValue = parseInt(dot_value) + 1
      target.attr('data-value', newValue).html(newValue)
      target.css background: Colours.dot(newValue) unless @layout is 'circle'
      dot.remove()
      $('body').css 'background-color' : Colours.background(newValue)
      @timer.end() if dot_value is "#{@count}"

  addDots: ->
    oldvalue = 1
    value = 1
    for i in [0..@count-1]
      $('#container').append "<div class='dot' data-value='#{value}' data-id='#{i}' >#{value}</div>"
      oldvalue = value
      value = oldvalue + 1
    $('#container').prepend '<div class="dot" data-value="1" data-id="1000" >1</div>'

  makeDotsDraggable: ->
    if(false)
      $('.dot').on 'touchstart': @startDrag
    else
      $('.dot').draggable
        stop: @hitDetection
        containment: "#container" 
        scroll: false

  
  startDrag: (event)=>
    dot = $ event.currentTarget
    if event.type isnt 'mousedown'
      dot.on
        'touchmove': @moveDrag
        'touchend': @endDrag
    offset = dot.offset()
    @pos = [offset.left, offset.top]
    @origin = @getCoors event
  
  moveDrag:(event)=>
    dot = $ event.currentTarget
    currentPos = @getCoors event
    deltaX = currentPos[0] - @origin[0]
    deltaY = currentPos[1] - @origin[1]
    dot.css
      left: ((@pos[0] + deltaX) + 30) + 'px'
      top: ((@pos[1] + deltaY) + 30) + 'px'
    false
  
  endDrag: (event)=>
    dot = $ event.currentTarget
    dot.off
      'touchmove': @moveDrag
      'touchend': @endDrag
    @hitDetection event
  
  getCoors: (e)->
    event = e.originalEvent
    coors = []
    if event.targetTouches and event.targetTouches.length
      thisTouch = event.targetTouches[0]
      coors[0] = thisTouch.clientX
      coors[1] = thisTouch.clientY
    else
      coors[0] = event.clientX
      coors[1] = event.clientY
    coors
  
  layoutDots : ->
    Layouts.random() if @layout is 'random'
    Layouts.grid() if @layout is 'grid'
    Layouts.moving() if @layout is 'moving'
    Layouts.circle() if @layout is 'circle'
    Layouts.tiny() if @layout is 'tiny'