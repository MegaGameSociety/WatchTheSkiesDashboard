angular.module('dashboardApp', ['timer', 'ngAnimate'])
  .controller('dashboardCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    $scope.nextRound = new moment();
    $scope.news = [];

    var apiCall = function() {
      $http.get('/api/dashboard_data').then(
        function successCallback(response) {
          // Hide the connection error if it begins working again.
          // See the Error callback for more information.
          $('#connection-error').hide();

          var result = response['data']['result'];
          $scope.terror = result['global_terror']['total'];
          $scope.paused = result['timer']['paused'];
          $scope.countries = result['countries'];
          $scope.controlMessage = result['timer']['control_message'];
          $scope.round = result['timer']['round'];

          // Note: The "Vatican" class does not actually exist anywhere yet.
          $('.body').toggleClass('alien', result['alien_comms']);
          $('.Vatican').toggleClass('alien', result['vatican_alien_comms']);

          // Set the News
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
          
          var nextRound = moment.unix(result['timer']['next_round']);
          if ($scope.nextRound.valueOf() != nextRound.valueOf()) {
            $scope.nextRound = moment(nextRound);
            $scope.roundDuration = $scope.nextRound.diff(moment(), 'seconds');
            $scope.$broadcast('timer-set-countdown',  $scope.roundDuration);
            $scope.$broadcast('timer-start');
            $scope.$broadcast('timer-set-end-time',  $scope.roundDuration);
          }
        },
        function errorCallback(response) {
          // If we are having trouble with the API call, this will display a
          // small icon in the top right corner of the screen to signify that
          // there is a connection issue.
          $('#connection-error').show();
        });
    }

    // Make the News Slideshow work appropriately.
    // We use "index" here to refer to the position within the News array
    // that represents the current article. It starts with the first, and
    // adjusts on a timer.
    $scope.newsIndex = 0;

    $scope.setCurrentSlideIndex = function (index) {
      $scope.newsIndex = index;
    };

    $scope.isCurrentSlideIndex = function (index) {
      return $scope.newsIndex === index;
    };

    // Update the news index every 8 seconds.
    $interval(function(){
      $scope.newsIndex = ($scope.newsIndex < $scope.news.length - 1) ? ++$scope.newsIndex : 0;
    }, 8000);

    // Calculate the width of the Terror Tracker.
    // Based on a calculation of the Terror Tracker itself going up to 250.
    // But represented as a percentage out of 100%.
    $scope.getTerrorWidth = function() {
      var terror = $scope.terror;

      if (terror === undefined) {
        // If Terror hasn't been retrieved yet, don't break.
        $scope.terror_width = 0;
      } else if (terror > 250) {
        // Just in case.
        $scope.terror = 250;
        $scope.terror_width = 100;
      } else {
        $scope.terror_width = (100 / 250) * $scope.terror;
      }

      return {
        'width': $scope.terror_width + '%'
      };
    };

    // Get the colour of the Terror Tracker for the Display.
    // We simply return this as a class rather than having a colour set within
    // the JS, to ensure that our styling matches consistently.
    // (ie: if we want our red to be more red, it can be changed in one place.)
    $scope.getTerrorColour = function() {
      // Check to see if the Terror amount is between two numbers.
      function checkRange(x, n, m) {
        if (x >= n && x <= m) { return x; }
        else { return !x; }
      }

      // Store this simply so we don't have to keep calling it.
      var terror = $scope.terror;

      // Set colour based on the Terror amount.
      switch(terror) {
        case checkRange(terror, 1, 50):
          return'low';
          break;
        case checkRange(terror, 51, 100):
          return 'med';
          break;
        case checkRange(terror, 101, 150):
          return 'high';
          break;
        case checkRange(terror, 151, 200):
          return 'crit';
          break;
        case checkRange(terror, 201, 250):
          return 'doom';
          break;
        default:
          return 'none';
      }
    };

    // This is what calls our "refresh" method to make sure we are displaying
    // the most recently set data. It currently calls an update every 3 seconds.
    $scope.getStatus = function() {
      apiCall();
    };

    $scope.getStatus();

    $interval(function() {
      $scope.getStatus();
    }, 3000);
  }
]).animation('.slide-animation', function () {
  // Animation for the news articles where each one slides up after a timer
  // and the next one takes its place. Calculate's "finished" position based
  // on the height of the news articles.
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
