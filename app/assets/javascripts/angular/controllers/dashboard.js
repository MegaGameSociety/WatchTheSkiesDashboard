var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', []);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
    var apiCall = function() {

      $http.get('/api/dashboard_data').
      success(function(data, status, headers, config) {
        var result = data['result'];
        $scope.terror = result['global_terror']['total'];
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