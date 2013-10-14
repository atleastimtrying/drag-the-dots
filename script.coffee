# things to do
# - find slow bits speed them up
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
      console.log(coords)
      $(dot).css
        left: center.x - coords.x * 70 
        top: center.y - coords.y * 70
        background: "hsl(#{index * 30},60%, 60%)"
      $(dot).css({background: "hsl(30,60%, 60%)"}) if index is 0
      $('body').css 'background-color' : "hsl(30, 50%, 35%)"

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
    $('.again').click -> 
      $('body').trigger('startGame')
      false
    $('.showScores').click -> 
      $('body').trigger('show', 'scores')
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

class Screens
  constructor: (@app)->
    $('body').on 'show', (event, label)=> @[label]()

  name: ->
    $('#score, #scores, #start, .timer, #container').hide()
    $('#enterName').show()
  
  score: ->
    $('#container, #scores, #start, .timer, #enterName').hide()
    $('#score').show()
    $('#scoreMessage').html("#{@app.score} seconds!")
    $('body').trigger 'getName', (name)->
      $('body').trigger 'addScore', 
        level: @app.game.count 
        score: @app.score
        name: name 
      
  start: ->
    $('#container, #scores, #score, .timer, #enterName').hide()
    $('#start').show()

  scores: ->
    $('#container, #start, #score, .timer, #enterName').hide()
    $('#scores').show()
    $('body').trigger 'getScores', (scores)->
      html = 
        'score10': ''
        'score8': ''

      $(scores).each (index, score)->
        html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#scores table.table10 tbody').html(html['score10'])
      $('#scores table.table8 tbody').html(html['score8'])

class App
  constructor: ->
    @score = 0
    @storage = new Storage(@)
    @ui = new UI(@)
    @screens = new Screens(@)
    @game = new Game(@)
    $('body').trigger 'getName', (name)->
      if name
        $('body').trigger('show', 'start')
      else
        $('body').trigger('show', 'name')

