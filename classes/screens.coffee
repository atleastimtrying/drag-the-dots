class window.Screens
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

  credits: ->
    $('#credits').show()

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
        'score15': ''
        'score9': ''
        'score11': ''

      $(scores).each (index, score)->
        html["score#{score.level}"] += "<tr><td>#{score.name}</td><td>#{score.score}</td></tr>"
      $('#scores table.table10 tbody').html(html['score10'])
      $('#scores table.table8 tbody').html(html['score8'])
      $('#scores table.table12 tbody').html(html['score12'])
      $('#scores table.table15 tbody').html(html['score15'])
      $('#scores table.table9 tbody').html(html['score9'])
      $('#scores table.table11 tbody').html(html['score11'])
  highScores: ->
    $('#highScores, #highScores .spinner').show()
    $('body').trigger 'getHighScores', (data)->
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
      