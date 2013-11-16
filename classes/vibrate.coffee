class window.Vibrate
  constructor: (@app)->
    $('body').on 'collide', @vibrate
  vibrate: ->
    $('body').trigger 'getOption', 
      name: 'vibrate'
      fn: (vibrate)-> 
        navigator.notification.vibrate(200) if vibrate