(function() {
  angular.module('wtsApp').controller('incomeCtrl', ['$scope', function($scope) {
    $scope.selectedRound = 0;

    // Essentially the initialize function, but we need to specifically wait for
    // the API call on this, because the entire thing is based on retrieving both
    // the round, as well as the PR data.
    $scope.$on('APISuccess', function(event) {
      $scope.allRounds = $scope.getRounds();
      $scope.selectedRound = $scope.round;
      $scope.filterPr($scope.round);
    });

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
  }]);

})();
