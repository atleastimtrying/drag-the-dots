$ ->
  window.app = new App()
document.addEventListener "deviceready", ->
  document.ongesturechange = -> false
  document.addEventListener "menubutton", ->
    window.app.game.timer.stop()
    $('body').trigger('show', 'start') 
  , false
, false