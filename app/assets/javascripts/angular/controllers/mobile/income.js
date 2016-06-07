(function() {
  angular.module('wtsApp').controller('incomeCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    $scope.getRounds = function() {
      var allRounds = [];

      // This is for filtering by round.
      for (var i = 0; i <= $scope.round; i++) {
        allRounds.push(i);
      }

      return allRounds;
    }

    $scope.updateFilter = function() {
      $scope.filterPr($scope.selectedRound);
    }

    $scope.filterPr = function(round) {
      $scope.filtered_pr = $.map($scope.pr, function(relations) {
        // These come back as strings from the template.
        round = parseInt(round);

        if ((relations.team_id === $scope.myTeam.id)
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
        $scope.round = result['timer']['round'];
        $scope.pr = result['pr'];

        // Set the round data for Filtering PR by Round
        $scope.allRounds = $scope.getRounds();
        $scope.selectedRound = $scope.round;
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
