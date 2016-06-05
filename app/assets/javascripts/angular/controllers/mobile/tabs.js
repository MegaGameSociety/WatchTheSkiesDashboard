(function() {
  angular.module('wtsApp').controller('tabsCtrl', ['$scope', function($scope) {
    $scope.initializeTabs = function() {
      // Set the default Tab
      $scope.focusedTab = 'news';
    }

    $scope.checkPermissions = function(tab) {
      var myPermissions = $scope.roles[$scope.myRole].permissions;
      return myPermissions.indexOf(tab) !== -1;
    }

    // Tabs
    $scope.setTab = function(tab) {
      $scope.focusedTab = tab;
    }

    $scope.initializeTabs();
  }]);

})();
