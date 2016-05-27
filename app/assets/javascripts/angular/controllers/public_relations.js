angular.module('prApp', ['timer'])
  .controller('prCtrl', ['$scope', '$http', '$interval', '$window', function($scope, $http, $interval, $window) {


  $scope.myCountry = "Germany";
  $scope.myRole = "Head of State";

  $scope.focusedTab = 'income';

  $scope.setTab = function(tab) {
    $scope.focusedTab = tab;
  }

  $scope.nextRound = new moment();
  $scope.news = [];

  var apiCall = function() {
    $http.get('/api/dashboard_data').then(
      function successCallback(response) {
        // Hide the connection error if it begins working again.
        // See the Error callback for more information.
        $('#connection-error').hide();

        var result = response['data']['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];

        // Set the News
        if (result['news'].length > 0){
          var newDate = (new Date(result['news'][0]['created_at']));
          if (($scope.news.length == 0) || newDate.getTime() > $scope.lastUpdatedNews.getTime()) {
            $scope.lastUpdatedNews = newDate;
            $scope.news = result['news'];
          }
        } else {
          if ($scope.news.length == 0) {
            $scope.news = result['news'];
          }
        }
        var nextRound = moment(result['timer']['next_round']);
        if ($scope.nextRound.valueOf() != nextRound.valueOf()) {
          $scope.nextRound = moment(nextRound);
          $scope.roundDuration = $scope.nextRound.diff(moment(), 'seconds');
          $scope.$broadcast('timer-set-countdown',  $scope.roundDuration);
          $scope.$broadcast('timer-start');
          $scope.$broadcast('timer-set-end-time',  $scope.roundDuration);
        }
      },
      function errorCallback(response) {
        // If we are having trouble with the API call, this will display a
        // small icon in the top right corner of the screen to signify that
        // there is a connection issue.
        $('#connection-error').show();
      });
  }


  $scope.getStatus = function() {
    apiCall();
  };

  $scope.getStatus();

  $interval(function() {
    $scope.getStatus();
  }, 3000);

}]);
