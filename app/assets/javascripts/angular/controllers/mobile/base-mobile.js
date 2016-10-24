(function() {
  angular.module('wtsApp').controller('baseMobileCtrl', ['$scope', '$http', function($scope, $http) {

    // Set the default to be no permissions.
    $scope.myPermissions = [];

    $scope.sidebar = false;

    $scope.checkPermissions = function(tab) {
      var myPermissions = $scope.myPermissions;
      return myPermissions.indexOf(tab) !== -1;
    }

    $scope.toggleSidebar = function() {
      if ($scope.sidebar) {
        $scope.closeSidebar();
      } else {
        $scope.openSidebar();
      }
    }

    $scope.openSidebar = function() {
      $scope.sidebar = true;
    }

    $scope.closeSidebar = function() {
      $scope.sidebar = false;
    }

    // Tabs
    $scope.setTab = function(tab) {
      $scope.focusedTab = tab;
      // Close the sidebar if it is open
      $scope.closeSidebar();
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


        // Use Vorlon font if applicable.
        $('.mobile_dashboard').toggleClass('alien', result['alien_comms']);
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
