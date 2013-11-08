class window.Storage
  constructor: (@app)->
    $('body').on 
      'addScore': @addScore 
      'getScores': @getScores
      'clearScores': @clearScores
      'getName': @getName
      'setName': @setName
  
  sortByScore: (a,b)->
    response = 0
    response = -1 if a.score < b.score
    response = 1 if a.score > b.score
    response
  
  addScore: (event, data)=>
    scores = JSON.parse window.localStorage.getItem 'scores'
    scores = [] unless scores
    scores.push data
    grouped = _.groupBy scores, (obj)-> obj.level
    scores = []  
    for level, group of grouped
      group.sort @sortByScore
      group.length = 10 if group.length > 10
      scores = scores.concat group
    localStorage.setItem 'scores', JSON.stringify scores
  getScores: (event, fn)->
    fn JSON.parse window.localStorage.getItem 'scores'
  
  clearScores: (event)->
    localStorage.setItem 'scores', JSON.stringify []
    $('body').trigger('show', 'scores')

  getName: (event, fn)->
    fn localStorage.getItem 'name'

  setName: (event, name)->
    localStorage.setItem 'name', name
