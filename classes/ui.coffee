class window.UI
  constructor: ->
    $('body').trigger 'getName', (name)->
      if name
        $('.name').html(name)
        $('body').trigger('show', 'start')
      else
        $('body').trigger('show', 'name')
    @bindClicks()
  bindClicks: ->
    $('.not-name').click ->
      $('body').trigger 'setName', ''
      $('body').trigger 'show', 'name'
      false
    $('.startGame').click -> 
      $('body').trigger('startGame', {count: $(@).data('count'), layout: $(@).data('layout')})
      false
    $('.show').click -> 
      $('body').trigger('show', $(@).data('show'))
      false
    $('.action').click ->
      $('body').trigger($(@).data 'action')
      false
    $('#enterName button').on 'click', ->
      $('body').trigger 'setName', $('#enterName input').val()
      $('.name').html $('#enterName input').val()
      $('body').trigger('show', 'start')
      false
    $('.postHighScore').on 'click', ->
      $('body').trigger('show', 'highScores') 
      $('body').trigger 'getName', (name)->
        $('body').trigger 'postHighScore',
          score:
            level: @app.game.count 
            score: @app.score
            name: name
          fn: (data)->
            if data is 'FAILURE'
              alert('Oops! something went wrong!')
            else
              $('body').trigger('show', 'highScores')
      false