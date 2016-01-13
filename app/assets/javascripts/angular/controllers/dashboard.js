var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', ['timer', 'angular-svg-round-progress']);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
    $scope.nextRound = new moment();
    $scope.news = [];

    var apiCall = function() {
      $http.get('/api/dashboard_data').
      success(function(data, status, headers, config) {
        var result = data['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.activity = result['global_terror']['activity'];
        $scope.paused = result['timer']['paused'];
        $scope.countries = result['countries'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];
        $scope.rioters = result['global_terror']['rioters'];
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

    $scope.getTerrorAmount = function() {
      var terror = $scope.terror;
      var height;

      // If Terror hasn't been retrieved yet, don't break.
      if (terror === undefined) {
        height = 0;
      } else {
        height = $scope.terror * 2;
      }

      // Check to see if the Terror amount is between two numbers.
      function checkRange(x, n, m) {
        if (x >= n && x <= m) { return x; }
        else { return !x; }
      }

      // Set thermometer colour based on the Terror amount.
      switch(terror) {
        case checkRange(terror, 1, 50):
          color = "#6cc644";
          break;
        case checkRange(terror, 51, 100):
          color = "#44a662";
          break;
        case checkRange(terror, 101, 150):
          color = "#D5D506";
          break;
        case checkRange(terror, 151, 200):
          color = "#CB8F06";
          break;
        case checkRange(terror, 201, 250):
          color = "#bd2c00";
          break;
        default:
          color = "#FFFFFF";
      }

      // Return height and colour for thermometer.
      return {
        'height': height + 'px',
        'background-color': color
      };
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
