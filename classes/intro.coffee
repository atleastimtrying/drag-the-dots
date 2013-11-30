class window.Intro
  constructor: (@app)->
    $(@app).on 'startIntro', @start
    $('#intro .next').click @nextSlide
  start: =>
    $('body').css 'background', '#ccc'
    $('#intro section').hide()
    $('#intro .dot').show()
    $('#intro section#slide1').show()
    $('#intro .dot1').css 
      'left': '50%'
    $('#intro .dot2, #intro .dot4').css 
      'left': '30%'
    $('#intro .dot3, #intro .dot5').css 
      'left': '70%'
    $('#intro .dot').each ->
      $(@).css
        'top': '65%'
        'background-color': Colours.background Math.ceil Math.random() * 12
    
    $('#intro .dot1').draggable
      containment: "#intro"
      scroll: false
    
    $('#intro .dot2, #intro .dot3').draggable
      stop: @hitDetection1
      containment: "#intro"
      scroll: false
    
    $('#intro .dot4, #intro .dot5').draggable
      stop: @hitDetection2
      containment: "#intro"
      scroll: false

  collide: (item1, item2)->
    xs = item1.left - item2.left
    xs = xs * xs
    ys = item1.top - item2.top
    ys = ys * ys
    range = $('#intro .dot').width()
    dist = Math.sqrt xs + ys
    (dist < range)

  hitDetection1: (event)=>
    dot = $ '#intro .dot2'
    target = $ '#intro .dot3'
    if dot[0] and target[0]
      if @collide dot.offset(), target.offset()
        dot.fadeOut -> $(@).remove()
        target.html('2').css 'background', Colours.background(3)

  hitDetection2: (event)=>
    dot = $ '#intro .dot4'
    target = $ '#intro .dot5'
    if dot[0] and target[0]
      if @collide dot.offset(), target.offset()
        dot.fadeOut -> $(@).remove()
        target.html('2').css 'background', Colours.background(3)

  nextSlide: (event)=>
    $('#intro section').slideUp()
    $("#intro section#{$(event.currentTarget).attr('href')}").slideDown()
    false