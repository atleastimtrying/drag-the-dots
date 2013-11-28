class window.App
  constructor: ->
    @score = 0
    @scores = new Scores(@)
    @storage = new Storage(@)
    @ui = new UI(@)
    @intro = new Intro(@)
    @screens = new Screens(@)
    @game = new Game(@)
    @vibrate = new Vibrate(@) #if navigator.notification
    @options = new Options(@)
    @twitter = new Twitter(@)
    @facebook = new Facebook(@)
    $('body').trigger 'show', 'start'