(function() {
  angular.module('wtsApp').controller('incomeCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    var apiCall = function() {
      $http.get('/api/income_data').then(
      function successCallback(response) {
        $('#connection-error').hide();

        var result = response['data']['result'];

        $scope.pr = result['pr'];
        $scope.totalPr = result['total_pr'];
        $scope.reserves = result['reserves'];
        $scope.incomeLevel = result['income_level'];
        $scope.incomeValue = result['income_value'];
      },
      function errorCallback(response) {
        $('#connection-error').show();
      });
    }

    $scope.getPR = function() {
      apiCall();
    };

    $scope.getPR();

    $interval(function() {
      $scope.getPR();
    }, 3000);

  }]);

})();
