class window.UI
  constructor: (@app)->
    $(@app).trigger 'getName', (name)=>
      if name
        $('.name').html(name)
        $(@app).trigger('show', 'start')
      else
        $(@app).trigger('show', 'name')
    @bindClicks()
  bindClicks: =>
    $('.back-menu').click =>
      @app.game.menu()
    $('.not-name').click (event)=>
      event.preventDefault()
      $(@app).trigger 'setName', ''
      $(@app).trigger 'show', 'name'
    $('.startGame').click (event)=>
      event.preventDefault() 
      $(@app).trigger 'startGame',
        count: $(event.currentTarget).data('count')
        layout: $(event.currentTarget).data('layout')
    $('.startWall').click (event)=>
      event.preventDefault()
      $(@app).trigger('startWall')
    $('.show').click (event)=>
      event.preventDefault() 
      $(@app).trigger('show', $(event.currentTarget).data('show'))
    $('.action').click (event)=>
      event.preventDefault()
      $(@app).trigger($(event.currentTarget).data 'action')
    $('#enterName button').on 'click', (event)=>
      event.preventDefault()
      $(@app).trigger 'setName', $('#enterName input').val()
      $('.name').html $('#enterName input').val()
      $(@app).trigger('show', 'start')