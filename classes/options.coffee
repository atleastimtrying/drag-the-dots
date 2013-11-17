class window.Options
  constructor:(@app)->
    $('body').on 'updateOption', @updateOption
    $('body').on 'getOption', @getOption
    @setupOptions()
    @syncUI()

  setupOptions: =>
    options = @getOptions()
    unless options
      options = { 
        vibrate: true
        background: true
        numbers: true
        greyscale: false
      }
    localStorage.setItem 'options', JSON.stringify options

  updateOption: (event, obj)=>
    console.log obj
    options = JSON.parse localStorage.getItem 'options'
    options[obj.name] = obj.val
    localStorage.setItem 'options', JSON.stringify options

  getOptions: =>
    JSON.parse localStorage.getItem 'options'

  getOption: (event, obj)=>
    options = @getOptions()
    obj.fn options[obj.name]

  syncUI: =>
    options = @getOptions()
    $('#optionVibrate').attr('checked', options.vibrate )
    $('#optionBackground').attr('checked', options.background )
    $('#optionNumbers').attr('checked', options.numbers )
    $('#optionGreyscale').attr('checked', options.greyscale )