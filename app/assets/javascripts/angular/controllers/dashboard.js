var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', ['timer']);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
      $scope.nextRound = new Date();
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
        if (result['news'].length > 0){
          var newDate = (new Date(result['news'][0]['created_at']));
            if($scope.news.length == 0){
              $scope.lastUpdatedNews = newDate;
              $scope.news = result['news']
            }
          if (newDate.getTime() > $scope.lastUpdatedNews.getTime()){
            $scope.lastUpdatedNews = newDate;
            $scope.news = result['news']
            console.log ("Changing news");
          }
        }else{
          if($scope.news.length == 0){
            $scope.news = result['news']
          }
        }
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

    $scope.updateNews = function(){
      t = $scope.news.shift();
      $scope.news.push(t);
    }
    $interval(function(){$scope.updateNews()}, 10000);
    $interval(function() {
      $scope.getStatus()
    }, 3000);
  }
]);

