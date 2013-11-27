class window.Twitter
  constructor: (@app)->
    $('.btn.tweet').click @tweet
  url: (game, score)->
    game = game.replace "+", " plus"
    "https://twitter.com/intent/tweet?text=I+got+#{score}+on+#{game}+in+Drag+the+Dots%21+http%3A%2F%2Fmorein.fo%2Fdtd&via=dragthedots"
  tweet: (event)=>
    event.preventDefault()
    window.open(@url(@app.game.name() , @app.score), '_blank', 'location=no');