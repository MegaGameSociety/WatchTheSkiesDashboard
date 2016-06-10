(function() {
  angular.module('wtsApp').controller('baseMobileCtrl', ['$scope', '$http', function($scope, $http) {

    // Set the default to be no permissions.
    $scope.myPermissions = [];
    $scope.teams = [];

    $scope.checkPermissions = function(tab) {
      var myPermissions = $scope.myPermissions;
      return myPermissions.indexOf(tab) !== -1;
    }

    // Tabs
    $scope.setTab = function(tab) {
      $scope.focusedTab = tab;
    }

    var apiCall = function() {
      $http.get('/api/mobile_basic').then(
      function successCallback(response) {
        $('#connection-error').hide();

        var result = response['data']['result'];

        $scope.myCountryId = result['team']['id'];
        $scope.myCountryName = result['team']['team_name'];
        $scope.myRoleName = result['team_role']['role_display_name'];
        $scope.roleClass = `role-${result['team_role']['role_name']}`;
        $scope.myPermissions = result['team_role']['role_permissions'];

        $scope.teams = result['teams'];

        $scope.focusedTab = 'news';
      },
      function errorCallback(response) {
        $('#connection-error').show();
      });
    }

    // Unlike the dashboard information which contains Round or the Terror Tracker,
    // or the individual tab information which can contain Messages or Income,
    // this call does not run on an interval. We expect that someone's country,
    // role within that country, and permissions within that role are things
    // that will not change throughout the game.
    apiCall();

  }]);

})();
