class window.Vibrate
  constructor: (@app)->
    $('body').on 'collide', @vibrate
  vibrate: ->
    navigator.notification.vibrate(200)