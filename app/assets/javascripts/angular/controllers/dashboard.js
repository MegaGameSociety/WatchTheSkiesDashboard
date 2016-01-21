angular.module('dashboardApp', ['timer', 'ngAnimate'])
  .controller('dashboardCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    $scope.nextRound = new moment();
    $scope.news = [];

    var apiCall = function() {
      $http.get('/api/dashboard_data').
      success(function(data, status, headers, config) {
        var result = data['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.paused = result['timer']['paused'];
        $scope.countries = result['countries'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];

        $('.body').toggleClass('alien', result['alien_comms']);
        $('.Vatican').toggleClass('alien', result['vatican_alien_comms']);

        if (result['news'].length > 0){
          var newDate = (new Date(result['news'][0]['created_at']));
          if (($scope.news.length == 0) || newDate.getTime() > $scope.lastUpdatedNews.getTime()) {
            $scope.lastUpdatedNews = newDate;
            $scope.news = result['news'];
          }
        } else {
          if ($scope.news.length == 0) {
            $scope.news = result['news'];
          }
        }
        var nextRound = moment(result['timer']['next_round']);
        if ($scope.nextRound.valueOf() != nextRound.valueOf()) {
          $scope.nextRound = moment(nextRound);
          $scope.roundDuration = $scope.nextRound.diff(moment(), 'seconds');
          $scope.$broadcast('timer-set-countdown',  $scope.roundDuration);
          $scope.$broadcast('timer-start');
          $scope.$broadcast('timer-set-end-time',  $scope.roundDuration);
        }
      });
    }

    // Get the height of the Terror Tracker for the Thermometer Display.
    $scope.getTerrorHeight = function() {
    // Make the News Slideshow work appropriately.
    $scope.newsIndex = 0;

    $scope.setCurrentSlideIndex = function (index) {
        $scope.newsIndex = index;
    };

    $scope.isCurrentSlideIndex = function (index) {
        return $scope.newsIndex === index;
    };

    $interval(function(){
        $scope.newsIndex = ($scope.newsIndex < $scope.news.length - 1) ? ++$scope.newsIndex : 0;
    }, 8000);

      var terror = $scope.terror;

      // If Terror hasn't been retrieved yet, don't break.
      if (terror === undefined) {
        $scope.terror_height = 0;
      } else if (terror > 250) {
        $scope.terror = 250;
        $scope.terror_height = 370;
      } else {
        // 400 max pixels tall, -30 for padding.
        // Divided by 250, the maximum amount of the terror tracker.
        $scope.terror_height = (370 / 250) * $scope.terror;
      }

      // Return the height for the thermometer.
      return {
        'height': $scope.terror_height + 'px'
      };
    };

    // Get the colour of the Terror Tracker for the Thermometer Display.
    $scope.getTerrorColour = function() {
      // Check to see if the Terror amount is between two numbers.
      function checkRange(x, n, m) {
        if (x >= n && x <= m) { return x; }
        else { return !x; }
      }

      var terror = $scope.terror;
      // Set thermometer colour based on the Terror amount.
      // Rounded class is whether we include the rounded top for the thermometer,
      // which it does not make sense to include when the terror is low.
      switch(terror) {
        case checkRange(terror, 1, 50):
          return'low';
          break;
        case checkRange(terror, 51, 70):
          return 'med';
          break;
        case checkRange(terror, 71, 100):
          return 'med rounded';
          break;
        case checkRange(terror, 101, 150):
          return 'high rounded';
          break;
        case checkRange(terror, 151, 200):
          return 'crit rounded';
          break;
        case checkRange(terror, 201, 250):
          return 'doom rounded';
          break;
        default:
          return 'none';
      }
    };

    $scope.getStatus = function() {
      apiCall();
    };

    $scope.range = function(n) {
      return new Array(n);
    };

    $scope.getStatus();

    $interval(function() {
      $scope.getStatus();
    }, 3000);
  }
]).animation('.slide-animation', function () {
  return {
    beforeAddClass: function (element, className, done) {
      var scope = element.scope();

      if (className == 'ng-hide') {
        var finishPoint = $(element).parent().height();
        TweenMax.to(element, 0.5, {top: -finishPoint, onComplete: done });
      }
      else {
        done();
      }
    },
    removeClass: function (element, className, done) {
      var scope = element.scope();

      if (className == 'ng-hide') {
        $(element).removeClass('ng-hide');
        var startPoint = $(element).parent().height();
        TweenMax.fromTo(element, 0.5, { top: startPoint }, {top: 0, onComplete: done });
      }
      else {
        done();
      }
    }
  };
});
