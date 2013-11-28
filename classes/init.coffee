$ ->
  window.app = new App()
document.addEventListener "deviceready", ->
  document.ongesturechange = -> false
  document.addEventListener "menubutton", window.app.game.menu, false
  document.addEventListener "backbutton", window.app.game.menu, false
, false