var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', ['timer']);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
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

        if (result['alien_comms'] == true) {
          $("body").addClass("alien");
          $("p").addClass("alien");
          $("td").addClass("alien");
        } else {
          $("body").removeClass("alien");
          $("p").removeClass("alien");
          $("td").removeClass("alien");
        }
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

      // Return height thermometer.
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

    $scope.updateNews = function(){
      news_items = $('.news-container')
      news_items.first().hide('slow',function(){
          detach = news_items.first().detach()
          detach.insertAfter(news_items.last()).fadeIn('slow');
      });
    }

    $scope.range = function(n) {
      return new Array(n);
    };

    $scope.getStatus();

    $interval(function(){
      $scope.updateNews();
    }, 8000);

    $interval(function() {
      $scope.getStatus();
    }, 3000);
  }
]);
