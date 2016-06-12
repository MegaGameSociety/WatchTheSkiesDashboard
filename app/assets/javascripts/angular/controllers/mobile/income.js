(function() {
  angular.module('wtsApp').controller('incomeCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {

    var getRounds = function() {
      var allRounds = [];

      // This is for filtering by round.
      for (var i = 0; i <= $scope.round; i++) {
        allRounds.push(i);
      }

      return allRounds;
    }

    var setRounds = function() {
      $scope.allRounds = getRounds();
      $scope.selectedRound = $scope.round;
    }

    setRounds();

    $scope.$on('base_data_changed', function() {
      setRounds();
    })

    $scope.updateFilter = function() {
      filterPr($scope.selectedRound);
    }

    var filterPr = function(round) {
      $scope.filtered_pr = $.map($scope.pr, function(relations) {
        // These come back as strings from the template.
        round = parseInt(round);

        if ((relations.team_id === $scope.myCountryId)
        && (relations.round === round)) {
          return relations;
        }  else {
          return null;
        }
      });
    }

    var apiCall = function() {
      $http.get('/api/income_data').then(
      function successCallback(response) {
        $('#connection-error').hide();

        var result = response['data']['result'];

        // Reserves Array
        var reserves = result['reserves'];
        var total_reserves = _.reduce(reserves, function(total, reserve_item) {
          if (reserve_item.round === $scope.round) {
            return total += reserve_item.amount;
          }
          return total;
        }, 0);

        // PR Array
        var pr = result['pr'];

        // Total PR
        var total_pr = _.reduce(pr, function(total, pr_item) {
          if (pr_item.round === $scope.round) {
            return total += pr_item.pr_amount;
          }
          return total;
        }, 0);

        $scope.pr = pr;
        $scope.totalPr = total_pr;
        $scope.reserves = total_reserves;
        $scope.incomeLevel = result['income_level'];
        $scope.incomeValue = result['income_value'];

        $scope.updateFilter();

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
