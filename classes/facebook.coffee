class window.Facebook
  constructor: (@app)->
    $('.btn.facebook').click @share
  url: (game, score)->
    game = game.replace "+", " plus"
    "http://www.facebook.com/sharer/sharer.php?s=100&p[url]=http://morein.fo/dtd&p[images][0]=&p[title]=Drag%20the%20Dots&p[summary]=I%20got%20#{score}%20on%20#{game}%20in%20Drag%20the%20Dots"
  share: (event)=>
    event.preventDefault()
    debugger
    window.open(@url(@app.game.name() , @app.score), '_blank', 'location=no'); 
    #$(event.currentTarget).attr 'href', @url(@app.game.name() , @app.score)