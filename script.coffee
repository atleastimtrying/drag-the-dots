# things to do
# - find slow bits speed them up

class Scores 
  constructor: (@app)->
    $('body').bind 'getHighScores', @getHighScores
    $('body').bind 'postHighScore', @postHighScore
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
    $('body').bind 'addScore', @addScore
    $('body').bind 'getScores', @getScores
    $('body').bind 'clearScores', @clearScores
    $('body').bind 'getName', @getName
    $('body').bind 'setName', @setName
  
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
  
  stop: =>
    @going = false
    @app.score = @count/10
    $('body').trigger 'show', 'score'
  
  start: =>
    @count = 0
    @going = true
    @tick()

Layouts =
  random: ()->
    range = $('.dot').width()/2
    $('.dot').each (index, dot)=>
      $(dot).css
        top: Math.ceil(Math.random()* ($('#container').height() - (range * 2)))
        left: Math.ceil(Math.random()* ($('#container').width() - (range * 2)))
        background: "hsl(#{index * 30},60%, 60%)"
      $(dot).css({background: "hsl(30,60%, 60%)"}) if index is 0
      $('body').css 'background-color' : "hsl(30, 50%, 35%)"
  grid: ->
    count = $('.dot').length
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
    center = { x: ($('#container').width() /2) + 105, y: ($('#container').height() /2) + 105 }
    $('.dot').each (index, dot)=>
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
      if label is 'score'
        $('body').off('collide', change) 
        $('body').off('show', unbindbody) 
    $('body').on 'collide', change
    $('body').on 'show', unbindbody
    $('.dot').addClass('moving');
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
    $('#score, #scores, #start, #enterName').hide()
    $('#container, .timer').show()
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
      @timer.stop() if dot_value is "#{@count}"

  addDots: ->
    oldvalue = 1
    value = 1
    for i in [0..@count-1]
      $('#container').append "<div class='dot' data-value='#{value}' data-id='#{i}' >#{value}</div>"
      oldvalue = value
      value = oldvalue + 1
    $('#container').prepend '<div class="dot" data-value="1" data-id="1000" >1</div>'

  makeDotsDraggable: ->
    $('.dot').draggable
      stop: @hitDetection
      containment: "#container" 
      scroll: false
  layoutDots : ->
    if @layout is 'random'
      Layouts.random()
    if @layout is 'grid'
      Layouts.grid()
    if @layout is 'moving'
      Layouts.moving()

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
    $('.startRandom').click -> 
      $('body').trigger('startGame', {count: 10, layout: 'random'})
      false
    $('.startGrid').click -> 
      $('body').trigger('startGame', {count: 8, layout: 'grid'})
      false
    $('.startMoving').click -> 
      $('body').trigger('startGame', {count: 12, layout: 'moving'})
      false
    $('.again').click -> 
      $('body').trigger('startGame')
      false
    $('.showScores').click -> 
      $('body').trigger('show', 'scores')
      false
    $('.showHighScores').click -> 
      $('body').trigger('show', 'highScores')
      false
    $('.showStart').click -> 
      $('body').trigger('show', 'start')
      false
    $('.clearScores').click ->
      $('body').trigger('clearScores')
      false
    $('#enterName button').on 'click', ->
      $('body').trigger 'setName', $('#enterName input').val()
      $('.name').html $('#enterName input').val()
      $('body').trigger('show', 'start')
      false
    $('.postHighScore').on 'click', ->
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
            
class Screens
  constructor: (@app)->
    $('body').on 'show', (event, label)=> @[label]()
    $('body').on 'show', ()=>
      if navigator.onLine
        $('.btn.online').show()
      else
        $('.btn.online').hide()

  name: ->
    $('#score, #scores, #start, .timer, #container, #highScores').hide()
    $('#enterName').show()
  
  score: ->
    $('#container, #scores, #start, .timer, #enterName, #highScores').hide()
    $('#score').show()
    $('#scoreMessage').html("#{@app.score} seconds!")
    $('body').trigger 'getName', (name)->
      $('body').trigger 'addScore', 
        level: @app.game.count 
        score: @app.score
        name: name 
      
  start: ->
    $('#container, #scores, #score, .timer, #enterName, #highScores').hide()
    $('#start').show()

  scores: ->
    $('#container, #start, #score, .timer, #enterName, #highScores').hide()
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
    $('#container, #start, #score, .timer, #enterName, #scores').hide()
    $('#highScores').show()
    $('body').trigger 'getHighScores', (data)->
      html = 
        'score10': ''
        'score8': ''
        'score12': ''
      for level,scores of data
        for score in scores
          html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#highScores table.table8 tbody').html(html['score8'])
      $('#highScores table.table10 tbody').html(html['score10'])
      $('#highScores table.table12 tbody').html(html['score12'])
      
class App
  constructor: ->
    @score = 0
    @scores = new Scores(@)
    @storage = new Storage(@)
    @ui = new UI(@)
    @screens = new Screens(@)
    @game = new Game(@)
    $('body').trigger 'getName', (name)->
      if name
        $('body').trigger('show', 'start')
      else
        $('body').trigger('show', 'name')

