window.Colours =
  dot: (index)->
    options = window.app.options.getOptions()
    if options.background
      "hsl(#{index * 30},60%, 60%)"
    else
      "transparent"
  background: (index)->
    "hsl(#{index * 30},50%, 35%)"