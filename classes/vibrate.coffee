class window.Vibrate
  constructor: (@app)->
    $(@app).on 'collide', @vibrate
  vibrate: ->
    $(@app).trigger 'getOption', 
      name: 'vibrate'
      fn: (vibrate)-> 
        navigator.notification.vibrate(200) if vibrate