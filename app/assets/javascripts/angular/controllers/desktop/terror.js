(function() {
  angular.module('wtsApp').controller('terrorCtrl', ['$scope', function($scope) {
    // Calculate the width of the Terror Tracker.
    // Based on a calculation of the Terror Tracker itself going up to 250.
    // But represented as a percentage out of 100%.
    $scope.getTerrorWidth = function() {
      var terror = $scope.terror;

      if (terror === undefined) {
        // If Terror hasn't been retrieved yet, don't break.
        $scope.terror_width = 0;
      } else if (terror > 250) {
        // Just in case.
        $scope.terror = 250;
        $scope.terror_width = 100;
      } else {
        $scope.terror_width = (100 / 250) * $scope.terror;
      }

      return {
        'width': $scope.terror_width + '%'
      };
    };

    // Get the colour of the Terror Tracker for the Display.
    // We simply return this as a class rather than having a colour set within
    // the JS, to ensure that our styling matches consistently.
    // (ie: if we want our red to be more red, it can be changed in one place.)
    $scope.getTerrorColour = function() {
      // Check to see if the Terror amount is between two numbers.
      function checkRange(x, n, m) {
        if (x >= n && x <= m) { return x; }
        else { return !x; }
      }

      // Store this simply so we don't have to keep calling it.
      var terror = $scope.terror;

      // Set colour based on the Terror amount.
      switch(terror) {
        case checkRange(terror, 1, 50):
          return'low';
          break;
        case checkRange(terror, 51, 100):
          return 'med';
          break;
        case checkRange(terror, 101, 150):
          return 'high';
          break;
        case checkRange(terror, 151, 200):
          return 'crit';
          break;
        case checkRange(terror, 201, 250):
          return 'doom';
          break;
        default:
          return 'none';
      }
    };

  }]);
})();
