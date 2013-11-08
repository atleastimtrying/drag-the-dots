class window.Intro
  constructor: (@app)->
    $('body').on 'startIntro', @start
    $('#intro .next').click @nextSlide
  start: =>
    $('#intro section').hide()
    $('#intro .dot').show()
    $('#intro section#slide1').show()
    $('#intro .dot1').css 
      'left': '50%'
    $('#intro .dot2, #intro .dot4').css 
      'left': '30%'
    $('#intro .dot3, #intro .dot5').css 
      'left': '70%'
    $('#intro .dot').css(
      'top': '65%'
      'background-color': Colours.background(Math.random() * 12)
    ).draggable
      stop: -> $(@).fadeOut()

  nextSlide: (event)=>
    $('#intro section').slideUp()
    $("#intro section#{$(event.currentTarget).attr('href')}").slideDown()
    false