$ ->
  window.app = new App()
document.addEventListener "deviceready", ->
  document.ongesturechange = -> false
  document.addEventListener "menubutton", ->
    window.app.game.timer.stop()
    $(window.app).trigger('show', 'start') 
  , false
  document.addEventListener "backbutton", ->
    window.app.game.timer.stop()
    $(window.app).trigger('show', 'start') 
  , false
, false