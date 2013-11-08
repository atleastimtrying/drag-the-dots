# things to do
# - find slow bits speed them up

class Intro
  constructor: (@app)->
    $('body').on 'startIntro', @start
    $('#intro .next').click @nextSlide
  start: =>
    $('#intro section').hide()
    $('#intro section#slide1').show()
    $('#intro .dot').css 'top': '65%'
    $('#intro .dot1').css 
      'left': '50%'
    $('#intro .dot2, #intro .dot4').css 
      'left': '30%'
    $('#intro .dot3, #intro .dot5').css 
      'left': '70%'
    $('#intro .dot').css('background-color', "hsl(#{Math.random() * 360},60%, 60%)").draggable
      stop: -> $(@).fadeOut()

  nextSlide: (event)=>
    $('#intro section').slideUp()
    $("#intro section#{$(event.currentTarget).attr('href')}").slideDown()
    false

class Scores 
  constructor: (@app)->
    $('body').on 
      'getHighScores': @getHighScores
      'postHighScore': @postHighScore
  getHighScores: (event, fn)->
    path = 'http://dragthedots.herokuapp.com/scores.js'
    $.ajax path,
      dataType: 'jsonp',
      success: (data)->
        fn(data)
  postHighScore: (event, scoreObject)=>
    path = 'http://dragthedots.herokuapp.com/scores/new'
    $.extend scoreObject.score, { 'dfgget5th767': @generateCode() }
    $.ajax path,
      dataType: 'jsonp'
      data: scoreObject.score
      success: scoreObject.fn
  generateCode: ->
    d = new Date 
    lead_character = String.fromCharCode Math.floor d.getDate() * 3.2453
    int = (d.getMonth() + 1) * 456
    "#{lead_character}.?!#{int}"

class Storage
  constructor: (@app)->
    $('body').on 
      'addScore': @addScore 
      'getScores': @getScores
      'clearScores': @clearScores
      'getName': @getName
      'setName': @setName
  
  sortByScore: (a,b)->
    response = 0
    response = -1 if a.score < b.score
    response = 1 if a.score > b.score
    response
  
  addScore: (event, data)=>
    scores = JSON.parse window.localStorage.getItem 'scores'
    scores = [] unless scores
    scores.push data
    grouped = _.groupBy scores, (obj)-> obj.level
    scores = []  
    for level, group of grouped
      group.sort @sortByScore
      group.length = 10 if group.length > 10
      scores = scores.concat group
    localStorage.setItem 'scores', JSON.stringify scores
  getScores: (event, fn)->
    fn JSON.parse window.localStorage.getItem 'scores'
  
  clearScores: (event)->
    localStorage.setItem 'scores', JSON.stringify []
    $('body').trigger('show', 'scores')

  getName: (event, fn)->
    fn localStorage.getItem 'name'

  setName: (event, name)->
    localStorage.setItem 'name', name

class Timer
  constructor: (@app)->
    @going = false
    @count = 0
  
  tick: =>
    $('.timer').html @count/10
    @count += 1
    window.setTimeout(@tick, 100) if @going
  
  end: =>
    @going = false
    @app.score = @count/10
    $('body').trigger 'show', 'score'
  
  start: =>
    @count = 0
    @going = true
    @tick()

  stop: =>
    @going = false
    @count = 0


Layouts =
  random: ()->
    range = $('#container .dot').width()/2
    $('#container .dot').each (index, dot)=>
      $(dot).css
        top: Math.ceil(Math.random()* ($('#container').height() - (range * 2)))
        left: Math.ceil(Math.random()* ($('#container').width() - (range * 2)))
        background: "hsl(#{index * 30},60%, 60%)"
      $(dot).css({background: "hsl(30,60%, 60%)"}) if index is 0
      $('body').css 'background-color' : "hsl(30, 50%, 35%)"
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
    center = { x: ($('#container').width() /2) + 85, y: ($('#container').height() /2) + 85 }
    $('#container .dot').each (index, dot)=>
      coords = layouts[index]
      $(dot).css
        left: center.x - coords.x * 70 
        top: center.y - coords.y * 70
        background: "hsl(#{index * 30},60%, 60%)"
      $(dot).css({background: "hsl(30,60%, 60%)"}) if index is 0
      $('body').css 'background-color' : "hsl(30, 50%, 35%)"
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

class Game 
  constructor: (@app)->
    $('body').on('startGame', @startGame)
    @count = 10
    @timer = new Timer(@app)
    @range = 30

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
    (item1.top < item2.top + @range and
    item1.top > item2.top - @range and
    item1.left < item2.left + @range and
    item1.left > item2.left - @range)
  
  hitDetection: (event)=>
    dot = $ event.target
    dotid = dot.attr('data-id')
    dot_value = dot.attr('data-value')
    target = $("[data-value=#{dot_value}]").not("[data-id=#{dotid}]")
    if target[0] and @collide(dot.offset(), target.offset())

      $('body').trigger 'collide'
      newValue = parseInt(dot_value) + 1
      target.attr('data-value', newValue).html(newValue).css
        background: "hsl(#{newValue * 30},60%, 60%)"
      dot.remove()
      $('body').css 'background-color' : "hsl(#{newValue * 30},50%, 35%)"
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
    $('.dot').on 'touchstart': @startDrag
  
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
      console.log event
      coors[0] = event.clientX
      coors[1] = event.clientY
    coors
  
  layoutDots : ->
    Layouts.random() if @layout is 'random'
    Layouts.grid() if @layout is 'grid'
    Layouts.moving() if @layout is 'moving'

$ ->
  window.app = new App()

class UI
  constructor: ->
    $('body').trigger 'getName', (name)->
      if name
        $('.name').html(name)
        $('body').trigger('show', 'start')
      else
        $('body').trigger('show', 'name')
    @bindClicks()
  bindClicks: ->
    $('.not-name').click ->
      $('body').trigger 'setName', ''
      $('body').trigger 'show', 'name'
      false
    $('.startGame').click -> 
      $('body').trigger('startGame', {count: $(@).data('count'), layout: $(@).data('layout')})
      false
    $('.show').click -> 
      $('body').trigger('show', $(@).data('show'))
      false
    $('.action').click ->
      $('body').trigger($(@).data 'action')
      false
    $('#enterName button').on 'click', ->
      $('body').trigger 'setName', $('#enterName input').val()
      $('.name').html $('#enterName input').val()
      $('body').trigger('show', 'start')
      false
    $('.postHighScore').on 'click', ->
      $('body').trigger('show', 'highScores') 
      $('body').trigger 'getName', (name)->
        $('body').trigger 'postHighScore',
          score:
            level: @app.game.count 
            score: @app.score
            name: name
          fn: (data)->
            if data is 'FAILURE'
              alert('Oops! something went wrong!')
            else
              $('body').trigger('show', 'highScores')
      false
class Screens
  constructor: (@app)->
    $('body').on 'show', (event, label)=>
      $('.screen').hide()
      @[label]()
    $('body').on 'show', ()=>
      if navigator.onLine
        $('.btn.online').show()
      else
        $('.btn.online').hide()

  name: ->
    $('#enterName').show()
  
  game: ->
    $('#container').show()

  intro: ->
    $('#intro').show()
    $('body').trigger 'startIntro'

  options: ->
    $('#options').show()
      
  start: ->
    $('body').trigger 'getName', (name)->
      if name
        $('#start').show()
      else
        $('body').trigger('show', 'name')

  score: ->
    $('#score').show()
    $('#scoreMessage').html("#{@app.score} seconds!")
    $('body').trigger 'getName', (name)->
      $('body').trigger 'addScore', 
        level: @app.game.count 
        score: @app.score
        name: name 

  scores: ->
    $('#scores').show()
    $('body').trigger 'getScores', (scores)->
      html = 
        'score10': ''
        'score8': ''
        'score12': ''

      $(scores).each (index, score)->
        html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#scores table.table10 tbody').html(html['score10'])
      $('#scores table.table8 tbody').html(html['score8'])
      $('#scores table.table12 tbody').html(html['score12'])
  highScores: ->
    $('#highScores, #highScores .spinner').show()
    $('body').trigger 'getHighScores', (data)->
      html = 
        'score10': ''
        'score8': ''
        'score12': ''
      for level,scores of data
        for score in scores
          html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#highScores .spinner').hide()
      $('#highScores table.table8 tbody').html(html['score8'])
      $('#highScores table.table10 tbody').html(html['score10'])
      $('#highScores table.table12 tbody').html(html['score12'])
      
class App
  constructor: ->
    @score = 0
    @scores = new Scores(@)
    @storage = new Storage(@)
    @ui = new UI(@)
    @intro = new Intro(@)
    @screens = new Screens(@)
    @game = new Game(@)
    $('body').trigger 'show', 'start'
document.addEventListener "deviceready", ->
  document.ongesturechange = -> false
  document.addEventListener "menubutton", ->
    window.app.game.timer.stop()
    $('body').trigger('show', 'start') 
  , false
, false
    