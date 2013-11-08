class window.Scores 
  constructor: (@app)->
    $('body').on 
      'getHighScores': @getHighScores
      'postHighScore': @postHighScore
  getHighScores: (event, fn)->
    path = 'http://dragthedots.com/scores.js'
    $.ajax path,
      dataType: 'jsonp',
      success: (data)->
        fn(data)
  postHighScore: (event, scoreObject)=>
    path = 'http://dragthedots.com/scores/new'
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