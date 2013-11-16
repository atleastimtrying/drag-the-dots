window.Colours =
  dot: (index)->
    options = window.app.options.getOptions()
    if options.background
      if options.greyscale
        "hsl(0,0%,#{index * 5}%)"
      else
        "hsl(#{index * 30},60%, 60%)"
    else
      "transparent"
  background: (index)->
    options = window.app.options.getOptions()
    if options.greyscale
      "hsl(0,0%,#{index * 2}%)"
    else
      "hsl(#{index * 30},50%, 35%)"