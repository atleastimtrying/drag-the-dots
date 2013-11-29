class window.Stats
  constructor:(@app)->
    $(@app).on 'stat_hit', @hit
    $(@app).on 'stat_miss', @miss
    $(@app).on 'stat_time', @time
    $(@app).on 'fetch_stats', @fetch_stats
    @setupStats()
  setupStats: =>
    stats = @getStats()
    unless stats
      stats = { 
        hits: 0
        misses: 0
        seconds: 0 
      }
    localStorage.setItem 'stats', JSON.stringify stats

  updateStat: (name, increment)=>
    stats = JSON.parse localStorage.getItem 'stats'
    stats[name] += increment
    localStorage.setItem 'stats', JSON.stringify stats

  getStats: =>
    JSON.parse localStorage.getItem 'stats'

  getStat: (event, name)=>
    stats = @getStats()
    stats[name]

  fetch_stats: (event, fn)=>
    fn @getStats()

  hit: =>
    @updateStat 'hits', 1

  miss: =>
    @updateStat 'misses', 1

  time: (event, seconds)=>
    @updateStat 'seconds', seconds