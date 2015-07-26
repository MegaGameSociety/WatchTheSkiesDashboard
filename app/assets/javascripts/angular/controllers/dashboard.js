var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', ['timer']);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
      $scope.nextRound = new Date();

    var apiCall = function() {
      $http.get('/api/dashboard_data').
      success(function(data, status, headers, config) {
        var result = data['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.paused = result['timer']['paused'];
        $scope.round = result['timer']['round'];
        $scope.countries = result['countries'];
        // debugger;
        var nextRound = new Date(result['timer']['next_round']);
        // The next round has changed
        if($scope.nextRound.getTime() != nextRound.getTime()){
          $scope.nextRound = nextRound;
          now = new Date();
          $scope.roundDuration = Math.abs($scope.nextRound - now)/1000;
          $scope.$broadcast('timer-set-countdown',  $scope.roundDuration);
          $scope.$broadcast('timer-start');
          $scope.$broadcast('timer-set-end-time',  $scope.roundDuration);
        }
      });
    }
    $scope.getStatus = function() {
      apiCall();
    };

    $scope.getStatus();
    $interval(function() {
      $scope.getStatus()
    }, 3000);
  }
]);

