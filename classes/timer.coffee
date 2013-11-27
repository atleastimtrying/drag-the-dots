class window.Timer
  constructor: (@app)->
    @going = false
    @count = 0
  
  tick: =>
    fraction = @count/10
    $('.timer').html fraction.toFixed(1)
    @count += 1
    window.setTimeout(@tick, 100) if @going
  
  end: =>
    @going = false
    @app.score = @count/10
    $(@app).trigger 'show', 'score'
  
  start: =>
    @count = 0
    @going = true
    @tick()

  stop: =>
    @going = false
    @count = 0