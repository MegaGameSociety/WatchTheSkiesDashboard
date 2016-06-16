(function() {
  angular.module('wtsApp').controller('incomeCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    var calculateTotalPr = function(pr) {
      return _.reduce(pr, function(total, item) {
        return total += item.pr_amount;
      }, 0);
    };

    var apiCall = function() {
      $http.get('/api/income_data').then(
      function successCallback(response) {
        $('#connection-error').hide();

        var result = response['data']['result'];
        $scope.reserves = result['reserves'] || 0;
        $scope.incomeLevel = result['income_level'];
        $scope.incomeValue = result['income_value'];

        $scope.pr = result['pr'];
        $scope.totalPr = calculateTotalPr(result['pr']);
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
