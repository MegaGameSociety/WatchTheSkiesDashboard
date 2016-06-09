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
        $scope.pr = response['data']['result']['pr'];
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
