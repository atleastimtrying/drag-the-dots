(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.App = (function() {

    function App() {
      this.score = 0;
      this.scores = new Scores(this);
      this.storage = new Storage(this);
      this.ui = new UI(this);
      this.intro = new Intro(this);
      this.screens = new Screens(this);
      this.game = new Game(this);
      this.vibrate = new Vibrate(this);
      this.twitter = new Twitter(this);
      $('body').trigger('show', 'start');
    }

    return App;

  })();

  window.Colours = {
    dot: function(index) {
      return "hsl(" + (index * 30) + ",60%, 60%)";
    },
    background: function(index) {
      return "hsl(" + (index * 30) + ",50%, 35%)";
    }
  };

  window.Game = (function() {

    function Game(app) {
      this.app = app;
      this.endDrag = __bind(this.endDrag, this);
      this.moveDrag = __bind(this.moveDrag, this);
      this.startDrag = __bind(this.startDrag, this);
      this.hitDetection = __bind(this.hitDetection, this);
      this.startGame = __bind(this.startGame, this);
      this.name = __bind(this.name, this);
      $('body').on('startGame', this.startGame);
      this.count = 10;
      this.timer = new Timer(this.app);
    }

    Game.prototype.name = function() {
      var count;
      count = this.count;
      return $(".table" + count).prev('h3').text();
    };

    Game.prototype.startGame = function(event, options) {
      if (options == null) {
        options = {
          count: this.count,
          layout: this.layout
        };
      }
      if (options.count) this.count = options.count;
      if (options.layout) this.layout = options.layout;
      $('body').trigger('show', 'game');
      $('#container .dot').remove();
      this.addDots();
      this.makeDotsDraggable();
      this.layoutDots();
      return this.timer.start();
    };

    Game.prototype.collide = function(item1, item2) {
      var dist, range, xs, ys;
      xs = item1.left - item2.left;
      xs = xs * xs;
      ys = item1.top - item2.top;
      ys = ys * ys;
      range = $('#container .dot').width();
      dist = Math.sqrt(xs + ys);
      return dist < range;
    };

    Game.prototype.hitDetection = function(event) {
      var dot, dot_value, dotid, newValue, target;
      dot = $(event.target);
      dotid = dot.attr('data-id');
      dot_value = dot.attr('data-value');
      target = $("[data-value=" + dot_value + "]").not("[data-id=" + dotid + "]");
      if (target[0] && this.collide(dot.offset(), target.offset())) {
        $('body').trigger('collide');
        newValue = parseInt(dot_value) + 1;
        target.attr('data-value', newValue).html(newValue);
        target.css({
          background: this.layout !== 'circle' ? Colours.dot(newValue) : void 0
        });
        dot.remove();
        $('body').css({
          'background-color': Colours.background(newValue)
        });
        if (dot_value === ("" + this.count)) return this.timer.end();
      }
    };

    Game.prototype.addDots = function() {
      var i, oldvalue, value, _ref;
      oldvalue = 1;
      value = 1;
      for (i = 0, _ref = this.count - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        $('#container').append("<div class='dot' data-value='" + value + "' data-id='" + i + "' >" + value + "</div>");
        oldvalue = value;
        value = oldvalue + 1;
      }
      return $('#container').prepend('<div class="dot" data-value="1" data-id="1000" >1</div>');
    };

    Game.prototype.makeDotsDraggable = function() {
      if (false) {
        return $('.dot').on({
          'touchstart': this.startDrag
        });
      } else {
        return $('.dot').draggable({
          stop: this.hitDetection,
          containment: "#container",
          scroll: false
        });
      }
    };

    Game.prototype.startDrag = function(event) {
      var dot, offset;
      dot = $(event.currentTarget);
      if (event.type !== 'mousedown') {
        dot.on({
          'touchmove': this.moveDrag,
          'touchend': this.endDrag
        });
      }
      offset = dot.offset();
      this.pos = [offset.left, offset.top];
      return this.origin = this.getCoors(event);
    };

    Game.prototype.moveDrag = function(event) {
      var currentPos, deltaX, deltaY, dot;
      dot = $(event.currentTarget);
      currentPos = this.getCoors(event);
      deltaX = currentPos[0] - this.origin[0];
      deltaY = currentPos[1] - this.origin[1];
      dot.css({
        left: ((this.pos[0] + deltaX) + 30) + 'px',
        top: ((this.pos[1] + deltaY) + 30) + 'px'
      });
      return false;
    };

    Game.prototype.endDrag = function(event) {
      var dot;
      dot = $(event.currentTarget);
      dot.off({
        'touchmove': this.moveDrag,
        'touchend': this.endDrag
      });
      return this.hitDetection(event);
    };

    Game.prototype.getCoors = function(e) {
      var coors, event, thisTouch;
      event = e.originalEvent;
      coors = [];
      if (event.targetTouches && event.targetTouches.length) {
        thisTouch = event.targetTouches[0];
        coors[0] = thisTouch.clientX;
        coors[1] = thisTouch.clientY;
      } else {
        coors[0] = event.clientX;
        coors[1] = event.clientY;
      }
      return coors;
    };

    Game.prototype.layoutDots = function() {
      if (this.layout === 'random') Layouts.random();
      if (this.layout === 'grid') Layouts.grid();
      if (this.layout === 'moving') Layouts.moving();
      if (this.layout === 'circle') Layouts.circle();
      if (this.layout === 'tiny') return Layouts.tiny();
    };

    return Game;

  })();

  $(function() {
    return window.app = new App();
  });

  document.addEventListener("deviceready", function() {
    document.ongesturechange = function() {
      return false;
    };
    document.addEventListener("menubutton", function() {
      window.app.game.timer.stop();
      return $('body').trigger('show', 'start');
    }, false);
    return document.addEventListener("backbutton", function() {
      window.app.game.timer.stop();
      return $('body').trigger('show', 'start');
    }, false);
  }, false);

  window.Intro = (function() {

    function Intro(app) {
      this.app = app;
      this.nextSlide = __bind(this.nextSlide, this);
      this.start = __bind(this.start, this);
      $('body').on('startIntro', this.start);
      $('#intro .next').click(this.nextSlide);
    }

    Intro.prototype.start = function() {
      $('#intro section').hide();
      $('#intro .dot').show();
      $('#intro section#slide1').show();
      $('#intro .dot1').css({
        'left': '50%'
      });
      $('#intro .dot2, #intro .dot4').css({
        'left': '30%'
      });
      $('#intro .dot3, #intro .dot5').css({
        'left': '70%'
      });
      return $('#intro .dot').css({
        'top': '65%',
        'background-color': Colours.background(Math.random() * 12)
      }).draggable({
        stop: function() {
          return $(this).fadeOut();
        }
      });
    };

    Intro.prototype.nextSlide = function(event) {
      $('#intro section').slideUp();
      $("#intro section" + ($(event.currentTarget).attr('href'))).slideDown();
      return false;
    };

    return Intro;

  })();

  window.Layouts = {
    random: function() {
      var range;
      var _this = this;
      range = $('#container .dot').width() / 2;
      return $('#container .dot').each(function(index, dot) {
        $(dot).css({
          top: Math.ceil(Math.random() * ($('#container').height() - (range * 2))),
          left: Math.ceil(Math.random() * ($('#container').width() - (range * 2))),
          background: Colours.dot(index)
        });
        if (index === 0) {
          $(dot).css({
            background: Colours.dot(1)
          });
        }
        return $('body').css({
          'background-color': Colours.background(1)
        });
      });
    },
    grid: function() {
      var center, count, difference, edge, i, layouts, x, y, _ref;
      var _this = this;
      count = $('#container .dot').length;
      layouts = [];
      edge = Math.floor(Math.sqrt(count)) - 1;
      x = 0;
      y = 0;
      for (i = 0, _ref = count - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        layouts.push({
          x: x,
          y: y
        });
        if (x < edge) {
          x += 1;
        } else {
          x = 0;
          y += 1;
        }
      }
      layouts = layouts.sort(function() {
        return 0.5 - Math.random();
      });
      difference = (edge + 1) / 2 * 60;
      center = {
        x: ($('#container').width() / 2) + difference,
        y: ($('#container').height() / 2) + difference
      };
      return $('#container .dot').each(function(index, dot) {
        var coords;
        coords = layouts[index];
        $(dot).css({
          left: center.x - coords.x * 70,
          top: center.y - coords.y * 70,
          background: Colours.dot(index)
        });
        $(dot).css({
          background: index === 0 ? Colours.dot(1) : void 0
        });
        return $('body').css({
          'background-color': Colours.background(1)
        });
      });
    },
    moving: function() {
      var change, unbindbody;
      change = function() {
        var range;
        range = $('.dot').width() / 2;
        return $('.dot').each(function(index, dot) {
          return $(dot).css({
            top: Math.ceil(Math.random() * ($('#container').height() - (range * 2))),
            left: Math.ceil(Math.random() * ($('#container').width() - (range * 2)))
          });
        });
      };
      unbindbody = function(event, label) {
        $('body').off('collide', change);
        return $('body').off('show', unbindbody);
      };
      $('body').on({
        'collide': change,
        'show': unbindbody
      });
      $('#container .dot').addClass('moving');
      return Layouts.random();
    },
    circle: function() {
      var angle, centerx, centery, count, layouts, radians, radius;
      var _this = this;
      count = $('#container .dot').size();
      angle = 360 / count;
      radians = function(degrees) {
        return degrees * (Math.PI / 180);
      };
      centerx = $(window).width() / 2;
      centery = $(window).height() / 2;
      radius = Math.min(centerx, centery) * 0.8;
      layouts = [];
      $('#container .dot').each(function(i, dot) {
        var x, y;
        x = centerx + Math.sin(radians(i * angle)) * radius;
        y = centery + Math.cos(radians(i * angle)) * radius;
        return layouts.push({
          top: "" + y + "px",
          left: "" + x + "px"
        });
      });
      $('body').css({
        'background-color': '#333'
      });
      layouts = layouts.sort(function() {
        return 0.5 - Math.random();
      });
      return $('#container .dot').each(function(i, dot) {
        $(dot).css(layouts[i]);
        return $(dot).addClass('spinny');
      });
    },
    tiny: function() {
      $('#container .dot').addClass('tiny');
      return Layouts.grid();
    }
  };

  window.Scores = (function() {

    function Scores(app) {
      this.app = app;
      this.postHighScore = __bind(this.postHighScore, this);
      $('body').on({
        'getHighScores': this.getHighScores,
        'postHighScore': this.postHighScore
      });
    }

    Scores.prototype.getHighScores = function(event, fn) {
      var path;
      path = 'http://dragthedots.com/scores.js';
      return $.ajax(path, {
        dataType: 'jsonp',
        success: function(data) {
          return fn(data);
        }
      });
    };

    Scores.prototype.postHighScore = function(event, scoreObject) {
      var path;
      path = 'http://dragthedots.com/scores/new';
      $.extend(scoreObject.score, {
        'dfgget5th767': this.generateCode()
      });
      return $.ajax(path, {
        dataType: 'jsonp',
        data: scoreObject.score,
        success: scoreObject.fn
      });
    };

    Scores.prototype.generateCode = function() {
      var d, int, lead_character;
      d = new Date;
      lead_character = String.fromCharCode(Math.floor(d.getDate() * 3.2453));
      int = (d.getMonth() + 1) * 456;
      return "" + lead_character + ".?!" + int;
    };

    return Scores;

  })();

  window.Screens = (function() {

    function Screens(app) {
      var _this = this;
      this.app = app;
      $('body').on('show', function(event, label) {
        $('.screen').hide();
        return _this[label]();
      });
      $('body').on('show', function() {
        if (navigator.onLine) {
          return $('.btn.online').show();
        } else {
          return $('.btn.online').hide();
        }
      });
    }

    Screens.prototype.name = function() {
      return $('#enterName').show();
    };

    Screens.prototype.randomIntro = function() {
      return $('#randomIntro').show();
    };

    Screens.prototype.gridIntro = function() {
      return $('#gridIntro').show();
    };

    Screens.prototype.movingIntro = function() {
      return $('#movingIntro').show();
    };

    Screens.prototype.gridPlusIntro = function() {
      return $('#gridPlusIntro').show();
    };

    Screens.prototype.circleIntro = function() {
      return $('#circleIntro').show();
    };

    Screens.prototype.tinyIntro = function() {
      return $('#tinyIntro').show();
    };

    Screens.prototype.game = function() {
      return $('#container').show();
    };

    Screens.prototype.credits = function() {
      return $('#credits').show();
    };

    Screens.prototype.intro = function() {
      $('#intro').show();
      return $('body').trigger('startIntro');
    };

    Screens.prototype.options = function() {
      return $('#options').show();
    };

    Screens.prototype.start = function() {
      return $('body').trigger('getName', function(name) {
        if (name) {
          return $('#start').show();
        } else {
          return $('body').trigger('show', 'name');
        }
      });
    };

    Screens.prototype.score = function() {
      $('#score').show();
      $('#scoreMessage').html("" + this.app.score + " seconds!");
      return $('body').trigger('getName', function(name) {
        return $('body').trigger('addScore', {
          level: this.app.game.count,
          score: this.app.score,
          name: name
        });
      });
    };

    Screens.prototype.scores = function() {
      $('#scores').show();
      return $('body').trigger('getScores', function(scores) {
        var html;
        html = {
          'score10': '',
          'score8': '',
          'score12': '',
          'score15': '',
          'score9': '',
          'score19': ''
        };
        $(scores).each(function(index, score) {
          return html["score" + score.level] += "<tr><td>" + score.name + "</td><td>" + score.score + "</td></tr>";
        });
        $('#scores table.table10 tbody').html(html['score10']);
        $('#scores table.table8 tbody').html(html['score8']);
        $('#scores table.table12 tbody').html(html['score12']);
        $('#scores table.table15 tbody').html(html['score15']);
        $('#scores table.table9 tbody').html(html['score9']);
        return $('#scores table.table19 tbody').html(html['score19']);
      });
    };

    Screens.prototype.highScores = function() {
      $('#highScores, #highScores .spinner').show();
      return $('body').trigger('getHighScores', function(data) {
        var html, level, score, scores, _i, _len;
        html = {
          'score10': '',
          'score8': '',
          'score12': '',
          'score15': '',
          'score9': '',
          'score19': ''
        };
        for (level in data) {
          scores = data[level];
          for (_i = 0, _len = scores.length; _i < _len; _i++) {
            score = scores[_i];
            html["score" + score.level] += "<tr><td>" + score.name + "</td><td>" + score.score + "</td></tr>";
          }
        }
        $('#highScores .spinner').hide();
        $('#highScores table.table8 tbody').html(html['score8']);
        $('#highScores table.table10 tbody').html(html['score10']);
        $('#highScores table.table12 tbody').html(html['score12']);
        $('#highScores table.table15 tbody').html(html['score15']);
        $('#highScores table.table9 tbody').html(html['score9']);
        return $('#highScores table.table19 tbody').html(html['score19']);
      });
    };

    return Screens;

  })();

  window.Storage = (function() {

    function Storage(app) {
      this.app = app;
      this.addScore = __bind(this.addScore, this);
      $('body').on({
        'addScore': this.addScore,
        'getScores': this.getScores,
        'clearScores': this.clearScores,
        'getName': this.getName,
        'setName': this.setName
      });
    }

    Storage.prototype.sortByScore = function(a, b) {
      var response;
      response = 0;
      if (a.score < b.score) response = -1;
      if (a.score > b.score) response = 1;
      return response;
    };

    Storage.prototype.addScore = function(event, data) {
      var group, grouped, level, scores;
      scores = JSON.parse(window.localStorage.getItem('scores'));
      if (!scores) scores = [];
      scores.push(data);
      grouped = _.groupBy(scores, function(obj) {
        return obj.level;
      });
      scores = [];
      for (level in grouped) {
        group = grouped[level];
        group.sort(this.sortByScore);
        if (group.length > 10) group.length = 10;
        scores = scores.concat(group);
      }
      return localStorage.setItem('scores', JSON.stringify(scores));
    };

    Storage.prototype.getScores = function(event, fn) {
      return fn(JSON.parse(window.localStorage.getItem('scores')));
    };

    Storage.prototype.clearScores = function(event) {
      localStorage.setItem('scores', JSON.stringify([]));
      return $('body').trigger('show', 'scores');
    };

    Storage.prototype.getName = function(event, fn) {
      return fn(localStorage.getItem('name'));
    };

    Storage.prototype.setName = function(event, name) {
      return localStorage.setItem('name', name);
    };

    return Storage;

  })();

  window.Timer = (function() {

    function Timer(app) {
      this.app = app;
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);
      this.end = __bind(this.end, this);
      this.tick = __bind(this.tick, this);
      this.going = false;
      this.count = 0;
    }

    Timer.prototype.tick = function() {
      var fraction;
      fraction = this.count / 10;
      $('.timer').html(fraction.toFixed(1));
      this.count += 1;
      if (this.going) return window.setTimeout(this.tick, 100);
    };

    Timer.prototype.end = function() {
      this.going = false;
      this.app.score = this.count / 10;
      return $('body').trigger('show', 'score');
    };

    Timer.prototype.start = function() {
      this.count = 0;
      this.going = true;
      return this.tick();
    };

    Timer.prototype.stop = function() {
      this.going = false;
      return this.count = 0;
    };

    return Timer;

  })();

  window.Twitter = (function() {

    function Twitter(app) {
      this.app = app;
      this.tweet = __bind(this.tweet, this);
      $('.btn.tweet').click(this.tweet);
    }

    Twitter.prototype.url = function(game, score) {
      game = game.replace("+", " plus");
      return "https://twitter.com/intent/tweet?text=I+got+" + score + "+on+" + game + "+in+Drag+the+Dots%21+http%3A%2F%2Fmorein.fo%2Fdtd&via=dragthedots";
    };

    Twitter.prototype.tweet = function(event) {
      event.preventDefault();
      return window.plugins.childBrowser.showWebPage(this.url(this.app.game.name(), this.app.score));
    };

    return Twitter;

  })();

  window.UI = (function() {

    function UI() {
      $('body').trigger('getName', function(name) {
        if (name) {
          $('.name').html(name);
          return $('body').trigger('show', 'start');
        } else {
          return $('body').trigger('show', 'name');
        }
      });
      this.bindClicks();
    }

    UI.prototype.bindClicks = function() {
      $('.not-name').click(function() {
        $('body').trigger('setName', '');
        $('body').trigger('show', 'name');
        return false;
      });
      $('.startGame').click(function() {
        $('body').trigger('startGame', {
          count: $(this).data('count'),
          layout: $(this).data('layout')
        });
        return false;
      });
      $('.show').click(function() {
        $('body').trigger('show', $(this).data('show'));
        return false;
      });
      $('.action').click(function() {
        $('body').trigger($(this).data('action'));
        return false;
      });
      $('#enterName button').on('click', function() {
        $('body').trigger('setName', $('#enterName input').val());
        $('.name').html($('#enterName input').val());
        $('body').trigger('show', 'start');
        return false;
      });
      return $('.postHighScore').on('click', function() {
        $('body').trigger('show', 'highScores');
        $('body').trigger('getName', function(name) {
          return $('body').trigger('postHighScore', {
            score: {
              level: this.app.game.count,
              score: this.app.score,
              name: name
            },
            fn: function(data) {
              if (data === 'FAILURE') {
                return alert('Oops! something went wrong!');
              } else {
                return $('body').trigger('show', 'highScores');
              }
            }
          });
        });
        return false;
      });
    };

    return UI;

  })();

  window.Vibrate = (function() {

    function Vibrate(app) {
      this.app = app;
      $('body').on('collide', this.vibrate);
    }

    Vibrate.prototype.vibrate = function() {
      return navigator.notification.vibrate(200);
    };

    return Vibrate;

  })();

}).call(this);
