// Generated by CoffeeScript 1.6.3
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
      this.options = new Options(this);
      this.twitter = new Twitter(this);
      this.facebook = new Facebook(this);
      this.stats = new Stats(this);
      $(this).trigger('show', 'start');
    }

    return App;

  })();

  window.Colours = {
    dot: function(index) {
      var options;
      options = window.app.options.getOptions();
      if (options.background) {
        if (options.greyscale) {
          return "hsl(0,0%," + (index * 5) + "%)";
        } else {
          return "hsl(" + (index * 30) + ",60%, 60%)";
        }
      } else {
        return "transparent";
      }
    },
    background: function(index) {
      var options;
      options = window.app.options.getOptions();
      if (options.greyscale) {
        return "hsl(0,0%," + (index * 2) + "%)";
      } else {
        return "hsl(" + (index * 30) + ",50%, 35%)";
      }
    }
  };

  window.Facebook = (function() {
    function Facebook(app) {
      this.app = app;
      this.share = __bind(this.share, this);
      $('.btn.facebook').click(this.share);
    }

    Facebook.prototype.url = function(game, score) {
      game = game.replace("+", " plus");
      return "http://www.facebook.com/sharer/sharer.php?s=100&p[url]=http://morein.fo/dtd&p[images][0]=&p[title]=Drag%20the%20Dots&p[summary]=I%20got%20" + score + "%20on%20" + game + "%20in%20Drag%20the%20Dots";
    };

    Facebook.prototype.share = function(event) {
      event.preventDefault();
      return window.open(this.url(this.app.game.name(), this.app.score), '_blank', 'location=no');
    };

    return Facebook;

  })();

  window.Game = (function() {
    function Game(app) {
      this.app = app;
      this.endDrag = __bind(this.endDrag, this);
      this.moveDrag = __bind(this.moveDrag, this);
      this.startDrag = __bind(this.startDrag, this);
      this.hitDetection = __bind(this.hitDetection, this);
      this.startGame = __bind(this.startGame, this);
      this.menu = __bind(this.menu, this);
      this.name = __bind(this.name, this);
      $(this.app).on('startGame', this.startGame);
      this.count = 10;
      this.timer = new Timer(this.app);
      $('#container').on('touchmove', function(e) {
        return e.preventDefault();
      });
    }

    Game.prototype.name = function() {
      var count;
      count = this.count;
      return $(".table" + count).prev('h3').text();
    };

    Game.prototype.menu = function() {
      this.timer.stop();
      return $(this.app).trigger('show', 'start');
    };

    Game.prototype.startGame = function(event, options) {
      var _this = this;
      if (options == null) {
        options = {
          count: this.count,
          layout: this.layout
        };
      }
      if (options.count) {
        this.count = options.count;
      }
      if (options.layout) {
        this.layout = options.layout;
      }
      $(this.app).trigger('show', 'game');
      $('#container .dot').remove();
      this.addDots();
      this.makeDotsDraggable();
      this.layoutDots();
      return $(this.app).trigger('getOption', {
        name: 'numbers',
        fn: function(numbers) {
          if (!numbers) {
            $('#container .dot').addClass('no-numbers');
          }
          return _this.timer.start();
        }
      });
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
        $(this.app).trigger('collide');
        newValue = parseInt(dot_value) + 1;
        target.attr('data-value', newValue).html(newValue);
        if (this.layout !== 'circle') {
          target.css({
            background: Colours.dot(newValue)
          });
        }
        dot.remove();
        $(this.app).css({
          'background-color': Colours.background(newValue)
        });
        $(this.app).trigger('stat_hit');
        if (dot_value === ("" + this.count)) {
          return this.timer.end();
        }
      } else {
        return $(this.app).trigger('stat_miss');
      }
    };

    Game.prototype.addDots = function() {
      var i, oldvalue, value, _i, _ref;
      oldvalue = 1;
      value = 1;
      for (i = _i = 0, _ref = this.count - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
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
      if (this.layout === 'random') {
        Layouts.random();
      }
      if (this.layout === 'grid') {
        Layouts.grid();
      }
      if (this.layout === 'moving') {
        Layouts.moving();
      }
      if (this.layout === 'circle') {
        Layouts.circle();
      }
      if (this.layout === 'tiny') {
        return Layouts.tiny();
      }
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
    document.addEventListener("menubutton", window.app.game.menu, false);
    return document.addEventListener("backbutton", window.app.game.menu, false);
  }, false);

  window.Intro = (function() {
    function Intro(app) {
      this.app = app;
      this.nextSlide = __bind(this.nextSlide, this);
      this.start = __bind(this.start, this);
      $(this.app).on('startIntro', this.start);
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
      var range,
        _this = this;
      range = $('#container .dot').width() / 2;
      return $('#container .dot').each(function(index, dot) {
        $(dot).css({
          top: Math.ceil(Math.random() * ($('#container').height() - (range * 2) - 90)) + 90,
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
      var center, count, difference, edge, i, layouts, x, y, _i, _ref,
        _this = this;
      count = $('#container .dot').length;
      layouts = [];
      edge = Math.floor(Math.sqrt(count)) - 1;
      x = 0;
      y = 0;
      for (i = _i = 0, _ref = count - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
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
    moving: function() {
      var change, unbindbody;
      change = function() {
        var range;
        range = $('.dot').width() / 2;
        return $('.dot').each(function(index, dot) {
          return $(dot).css({
            top: Math.ceil(Math.random() * ($('#container').height() - (range * 2) - 90)) + 90,
            left: Math.ceil(Math.random() * ($('#container').width() - (range * 2)))
          });
        });
      };
      unbindbody = function(event, label) {
        $(window.app).off('collide', change);
        return $(window.app).off('show', unbindbody);
      };
      $(window.app).on({
        'collide': change,
        'show': unbindbody
      });
      $('#container .dot').addClass('moving');
      return Layouts.random();
    },
    circle: function() {
      var angle, bg, centerx, centery, count, layouts, options, radians, radius,
        _this = this;
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
      layouts = layouts.sort(function() {
        return 0.5 - Math.random();
      });
      options = window.app.options.getOptions();
      bg = "white";
      if (!options.background) {
        bg = "transparent";
      }
      $('#container .dot').each(function(i, dot) {
        $(dot).css({
          top: layouts[i].top,
          left: layouts[i].left,
          background: bg
        });
        return $(dot).addClass('spinny');
      });
      return $('body').css({
        'background-color': Colours.background(1)
      });
    },
    tiny: function() {
      $('#container .dot').addClass('tiny');
      return Layouts.grid();
    },
    walls: function() {
      $('#container .dot').addClass('outline');
      return Layouts.grid();
    }
  };

  window.Options = (function() {
    function Options(app) {
      this.app = app;
      this.syncUI = __bind(this.syncUI, this);
      this.getOption = __bind(this.getOption, this);
      this.getOptions = __bind(this.getOptions, this);
      this.updateOption = __bind(this.updateOption, this);
      this.setupOptions = __bind(this.setupOptions, this);
      $(this.app).on('updateOption', this.updateOption);
      $(this.app).on('getOption', this.getOption);
      this.setupOptions();
      this.syncUI();
      this.bindChanges();
    }

    Options.prototype.setupOptions = function() {
      var options;
      options = this.getOptions();
      if (!options) {
        options = {
          vibrate: false,
          background: true,
          numbers: true,
          greyscale: false
        };
      }
      return localStorage.setItem('options', JSON.stringify(options));
    };

    Options.prototype.updateOption = function(event, obj) {
      var options;
      options = JSON.parse(localStorage.getItem('options'));
      options[obj.name] = obj.val;
      return localStorage.setItem('options', JSON.stringify(options));
    };

    Options.prototype.getOptions = function() {
      return JSON.parse(localStorage.getItem('options'));
    };

    Options.prototype.getOption = function(event, obj) {
      var options;
      options = this.getOptions();
      return obj.fn(options[obj.name]);
    };

    Options.prototype.syncUI = function() {
      var options;
      options = this.getOptions();
      this.checkIfOption('#optionVibrate', options.vibrate);
      this.checkIfOption('#optionBackground', options.background);
      this.checkIfOption('#optionNumbers', options.numbers);
      return this.checkIfOption('#optionGreyscale', options.greyscale);
    };

    Options.prototype.checkIfOption = function(selector, option) {
      var current, label;
      current = $(selector);
      label = $("label[for=" + (current.attr('id')) + "]");
      if (option) {
        current.attr('checked', 'checked');
        return label.addClass('checked');
      } else {
        current.attr('checked', false);
        return label.removeClass('checked');
      }
    };

    Options.prototype.updateView = function(event, name) {
      var current, label;
      current = $(event.currentTarget);
      label = $("label[for=" + (current.attr('id')) + "]");
      $(this.app).trigger('updateOption', {
        name: name,
        val: current.is(":checked")
      });
      if (current.is(":checked")) {
        return label.addClass('checked');
      } else {
        return label.removeClass('checked');
      }
    };

    Options.prototype.bindChanges = function() {
      var _this = this;
      $('#optionVibrate').change(function(event) {
        return _this.updateView(event, 'vibrate');
      });
      $('#optionBackground').change(function(event) {
        return _this.updateView(event, 'background');
      });
      $('#optionGreyscale').change(function(event) {
        return _this.updateView(event, 'greyscale');
      });
      return $('#optionNumbers').change(function(event) {
        return _this.updateView(event, 'numbers');
      });
    };

    return Options;

  })();

  window.Scores = (function() {
    function Scores(app) {
      this.app = app;
      this.postHighScore = __bind(this.postHighScore, this);
      $(this.app).on({
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
      this.highScores = __bind(this.highScores, this);
      this.scores = __bind(this.scores, this);
      this.score = __bind(this.score, this);
      this.start = __bind(this.start, this);
      this.stats = __bind(this.stats, this);
      this.intro = __bind(this.intro, this);
      $(this.app).on('show', function(event, label) {
        $('.screen').hide();
        return _this[label]();
      });
      $(this.app).on('show', function() {
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
      return $(this.app).trigger('startIntro');
    };

    Screens.prototype.stats = function() {
      var _this = this;
      $('#stats').show();
      return $(this.app).trigger('fetch_stats', function(stats) {
        $('#stat_hits').html(stats['hits']);
        $('#stat_misses').html(stats['misses']);
        return $('#stat_seconds').html(Math.ceil(stats['seconds']));
      });
    };

    Screens.prototype.options = function() {
      return $('#options').show();
    };

    Screens.prototype.start = function() {
      return $(this.app).trigger('getName', function(name) {
        if (name) {
          return $('#start').show();
        } else {
          return $(this.app).trigger('show', 'name');
        }
      });
    };

    Screens.prototype.score = function() {
      $('#score').show();
      $('#scoreMessage').html("" + this.app.score + " seconds!");
      return $(this.app).trigger('getName', function(name) {
        return $(this.app).trigger('addScore', {
          level: this.app.game.count,
          score: this.app.score,
          name: name
        });
      });
    };

    Screens.prototype.scores = function() {
      $('#scores').show();
      return $(this.app).trigger('getScores', function(scores) {
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
      return $(this.app).trigger('getHighScores', function(data) {
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

  window.Stats = (function() {
    function Stats(app) {
      this.app = app;
      this.time = __bind(this.time, this);
      this.miss = __bind(this.miss, this);
      this.hit = __bind(this.hit, this);
      this.fetch_stats = __bind(this.fetch_stats, this);
      this.getStat = __bind(this.getStat, this);
      this.getStats = __bind(this.getStats, this);
      this.updateStat = __bind(this.updateStat, this);
      this.setupStats = __bind(this.setupStats, this);
      $(this.app).on('stat_hit', this.hit);
      $(this.app).on('stat_miss', this.miss);
      $(this.app).on('stat_time', this.time);
      $(this.app).on('fetch_stats', this.fetch_stats);
      this.setupStats();
    }

    Stats.prototype.setupStats = function() {
      var stats;
      stats = this.getStats();
      if (!stats) {
        stats = {
          hits: 0,
          misses: 0,
          seconds: 0
        };
      }
      return localStorage.setItem('stats', JSON.stringify(stats));
    };

    Stats.prototype.updateStat = function(name, increment) {
      var stats;
      stats = JSON.parse(localStorage.getItem('stats'));
      stats[name] += increment;
      return localStorage.setItem('stats', JSON.stringify(stats));
    };

    Stats.prototype.getStats = function() {
      return JSON.parse(localStorage.getItem('stats'));
    };

    Stats.prototype.getStat = function(event, name) {
      var stats;
      stats = this.getStats();
      return stats[name];
    };

    Stats.prototype.fetch_stats = function(event, fn) {
      return fn(this.getStats());
    };

    Stats.prototype.hit = function() {
      return this.updateStat('hits', 1);
    };

    Stats.prototype.miss = function() {
      return this.updateStat('misses', 1);
    };

    Stats.prototype.time = function(event, seconds) {
      return this.updateStat('seconds', seconds);
    };

    return Stats;

  })();

  window.Storage = (function() {
    function Storage(app) {
      this.app = app;
      this.addScore = __bind(this.addScore, this);
      $(this.app).on({
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
      if (a.score < b.score) {
        response = -1;
      }
      if (a.score > b.score) {
        response = 1;
      }
      return response;
    };

    Storage.prototype.addScore = function(event, data) {
      var group, grouped, level, scores;
      scores = JSON.parse(window.localStorage.getItem('scores'));
      if (!scores) {
        scores = [];
      }
      scores.push(data);
      grouped = _.groupBy(scores, function(obj) {
        return obj.level;
      });
      scores = [];
      for (level in grouped) {
        group = grouped[level];
        group.sort(this.sortByScore);
        if (group.length > 10) {
          group.length = 10;
        }
        scores = scores.concat(group);
      }
      return localStorage.setItem('scores', JSON.stringify(scores));
    };

    Storage.prototype.getScores = function(event, fn) {
      return fn(JSON.parse(window.localStorage.getItem('scores')));
    };

    Storage.prototype.clearScores = function(event) {
      localStorage.setItem('scores', JSON.stringify([]));
      return $(this.app).trigger('show', 'scores');
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
      if (this.going) {
        return window.setTimeout(this.tick, 100);
      }
    };

    Timer.prototype.end = function() {
      this.going = false;
      this.app.score = this.count / 10;
      $(this.app).trigger('stat_time', this.count / 10);
      return $(this.app).trigger('show', 'score');
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
      return window.open(this.url(this.app.game.name(), this.app.score), '_blank', 'location=no');
    };

    return Twitter;

  })();

  window.UI = (function() {
    function UI(app) {
      var _this = this;
      this.app = app;
      this.bindClicks = __bind(this.bindClicks, this);
      $(this.app).trigger('getName', function(name) {
        if (name) {
          $('.name').html(name);
          return $(_this.app).trigger('show', 'start');
        } else {
          return $(_this.app).trigger('show', 'name');
        }
      });
      this.bindClicks();
    }

    UI.prototype.bindClicks = function() {
      var _this = this;
      $('.back-menu').click(function() {
        return _this.app.game.menu();
      });
      $('.not-name').click(function(event) {
        event.preventDefault();
        $(_this.app).trigger('setName', '');
        return $(_this.app).trigger('show', 'name');
      });
      $('.startGame').click(function(event) {
        event.preventDefault();
        return $(_this.app).trigger('startGame', {
          count: $(event.currentTarget).data('count'),
          layout: $(event.currentTarget).data('layout')
        });
      });
      $('.startWall').click(function(event) {
        event.preventDefault();
        return $(_this.app).trigger('startWall');
      });
      $('.show').click(function(event) {
        event.preventDefault();
        return $(_this.app).trigger('show', $(event.currentTarget).data('show'));
      });
      $('.action').click(function(event) {
        event.preventDefault();
        return $(_this.app).trigger($(event.currentTarget).data('action'));
      });
      $('#enterName button').on('click', function(event) {
        event.preventDefault();
        $(_this.app).trigger('setName', $('#enterName input').val());
        $('.name').html($('#enterName input').val());
        return $(_this.app).trigger('show', 'start');
      });
      return $('.postHighScore').on('click', function(event) {
        event.preventDefault();
        $(_this.app).trigger('show', 'highScores');
        $(_this.app).trigger('getName', function(name) {
          return $(_this.app).trigger('postHighScore', {
            score: {
              level: _this.app.game.count,
              score: _this.app.score,
              name: name
            },
            fn: function(data) {
              if (data === 'FAILURE') {
                return alert('Oops! something went wrong!');
              } else {
                return $(_this.app).trigger('show', 'highScores');
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
      $(this.app).on('collide', this.vibrate);
    }

    Vibrate.prototype.vibrate = function() {
      return $(this.app).trigger('getOption', {
        name: 'vibrate',
        fn: function(vibrate) {
          if (vibrate) {
            return navigator.notification.vibrate(200);
          }
        }
      });
    };

    return Vibrate;

  })();

}).call(this);
