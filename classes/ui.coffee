class window.UI
  constructor: (@app)->
    $(@app).trigger 'getName', (name)=>
      if name
        $('.name').html(name)
        $(@app).trigger('show', 'start')
      else
        $(@app).trigger('show', 'name')
    @bindClicks()
    @bindChanges()
  bindClicks: =>
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
    $('.postHighScore').on 'click', (event)=>
      event.preventDefault()
      $(@app).trigger('show', 'highScores') 
      $(@app).trigger 'getName', (name)=>
        $(@app).trigger 'postHighScore',
          score:
            level: @app.game.count 
            score: @app.score
            name: name
          fn: (data)=>
            if data is 'FAILURE'
              alert('Oops! something went wrong!')
            else
              $(@app).trigger('show', 'highScores')
  bindChanges: =>
    $('#optionVibrate').change (event)=>
      current = $(event.currentTarget)
      $(@app).trigger 'updateOption',
        name: 'vibrate'
        val: current.is(":checked")
      if current.is(":checked")
       $("label[for=#{current.attr('id')}]").addClass('checked') 
      else
       $("label[for=#{current.attr('id')}]").removeClass('checked')
    $('#optionBackground').change (event)=>
      current = $(event.currentTarget)
      $(@app).trigger 'updateOption',
        name: 'background'
        val: current.is(":checked")
      if current.is(":checked")
       $("label[for=#{current.attr('id')}]").addClass('checked') 
      else
       $("label[for=#{current.attr('id')}]").removeClass('checked')
    $('#optionGreyscale').change (event)=>
      current = $(event.currentTarget)
      $(@app).trigger 'updateOption',
        name: 'greyscale'
        val: current.is(":checked")
      if current.is(":checked")
       $("label[for=#{current.attr('id')}]").addClass('checked') 
      else
       $("label[for=#{current.attr('id')}]").removeClass('checked')
    $('#optionNumbers').change (event)=>
      current = $(event.currentTarget)
      $(@app).trigger 'updateOption',
        name: 'numbers'
        val: current.is(":checked")
      if current.is(":checked")
       $("label[for=#{current.attr('id')}]").addClass('checked') 
      else
       $("label[for=#{current.attr('id')}]").removeClass('checked')