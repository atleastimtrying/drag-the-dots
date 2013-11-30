class window.Screens
  constructor: (@app)->
    $(@app).on 'show', (event, label)=>
      $('.screen').hide()
      @[label]()
    $(@app).on 'show', ()=>
      if navigator.onLine
        $('.btn.online').show()
      else
        $('.btn.online').hide()

  name: ->
    $('#enterName').show()

  randomIntro: -> $('#randomIntro').show()
  gridIntro: -> $('#gridIntro').show()
  movingIntro: -> $('#movingIntro').show()
  gridPlusIntro: -> $('#gridPlusIntro').show()
  circleIntro: -> $('#circleIntro').show()
  tinyIntro: -> $('#tinyIntro').show()

  game: ->
    $('#container').show()

  credits: ->
    $('#credits').show()

  intro: =>
    $('#intro').show()
    $(@app).trigger 'startIntro'

  stats: =>
    $('#stats').show()
    $(@app).trigger 'fetch_stats', (stats)=>
      $('#stat_hits').html stats['hits']
      $('#stat_misses').html stats['misses']
      $('#stat_seconds').html Math.ceil stats['seconds']

  options: ->
    $('#options').show()
      
  start: =>
    $(@app).trigger 'getName', (name)=>
      if name
        $('#start').show()
      else
        $(@app).trigger('show', 'name')

  score: =>
    $('#score').show()
    $('#scoreMessage').html("#{@app.score} seconds!")
    $(@app).trigger 'getName', (name)=>
      $(@app).trigger 'addScore', 
        level: @app.game.count 
        score: @app.score
        name: name 

  scores: =>
    $('#scores').show()
    $(@app).trigger 'getScores', (scores)=>
      html = 
        'score10': ''
        'score8': ''
        'score12': ''
        'score15': ''
        'score9': ''
        'score19': ''

      $(scores).each (index, score)->
        html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#scores table.table10 tbody').html(html['score10'])
      $('#scores table.table8 tbody').html(html['score8'])
      $('#scores table.table12 tbody').html(html['score12'])
      $('#scores table.table15 tbody').html(html['score15'])
      $('#scores table.table9 tbody').html(html['score9'])
      $('#scores table.table19 tbody').html(html['score19'])
  highScores: =>
    $('#highScores, #highScores .spinner').show()
    $(@app).trigger 'getHighScores', (data)->
      html = 
        'score10': ''
        'score8': ''
        'score12': ''
        'score15': ''
        'score9': ''
        'score19': ''
      for level,scores of data
        for score in scores
          html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#highScores .spinner').hide()
      $('#highScores table.table8 tbody').html(html['score8'])
      $('#highScores table.table10 tbody').html(html['score10'])
      $('#highScores table.table12 tbody').html(html['score12'])
      $('#highScores table.table15 tbody').html(html['score15'])
      $('#highScores table.table9 tbody').html(html['score9'])
      $('#highScores table.table19 tbody').html(html['score19'])
      