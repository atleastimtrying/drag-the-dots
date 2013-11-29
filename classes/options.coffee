class window.Options
  constructor:(@app)->
    $(@app).on 'updateOption', @updateOption
    $(@app).on 'getOption', @getOption
    @setupOptions()
    @syncUI()
    @bindChanges()

  setupOptions: =>
    options = @getOptions()
    unless options
      options = { 
        vibrate: false
        background: true
        numbers: true
        greyscale: false
      }
    localStorage.setItem 'options', JSON.stringify options

  updateOption: (event, obj)=>
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
    @checkIfOption '#optionVibrate', options.vibrate
    @checkIfOption '#optionBackground', options.background
    @checkIfOption '#optionNumbers', options.numbers
    @checkIfOption '#optionGreyscale', options.greyscale

  checkIfOption: (selector, option)->
    current = $ selector
    label = $("label[for=#{current.attr('id')}]")
    if option
      current.attr('checked', 'checked')
      label.addClass('checked')
    else
      current.attr('checked', false)
      label.removeClass('checked')
  
  updateView: (event, name)->
    current = $ event.currentTarget
    label = $("label[for=#{current.attr('id')}]")
    $(@app).trigger 'updateOption',
      name: name
      val: current.is(":checked")
    if current.is(":checked")
     label.addClass('checked') 
    else
     label.removeClass('checked')
  
  bindChanges: ->
    $('#optionVibrate').change (event)=>
      @updateView(event, 'vibrate')
    $('#optionBackground').change (event)=>
      @updateView(event, 'background')
    $('#optionGreyscale').change (event)=>
      @updateView(event, 'greyscale')
    $('#optionNumbers').change (event)=>
      @updateView(event, 'numbers')
