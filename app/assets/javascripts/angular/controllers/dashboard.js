var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', ['timer', 'angular-svg-round-progress']);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http', '$interval',
  function($rootScope, $scope, $http, $interval) {
      $scope.nextRound = new moment();
      $scope.news = [];
    var apiCall = function() {
      $http.get('/api/dashboard_data').
      success(function(data, status, headers, config) {
        var result = data['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.activity = result['global_terror']['activity'];
        $scope.paused = result['timer']['paused'];
        $scope.countries = result['countries'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];
        $scope.rioters = result['global_terror']['rioters']

        if (result['alien_comms'] == true){
          // $(".alien").css("font-family", 'Vorlon', 'important');
          $( "body" ).addClass( "alien" );
          $( "p" ).addClass( "alien" );
        }else{
          // $(".alien").css("font-family", '');
          $( "body" ).removeClass( "alien" );
          $( "p" ).removeClass( "alien" );
        }

        if (result['news'].length > 0){
          var newDate = (new Date(result['news'][0]['created_at']));
            if($scope.news.length == 0){
              $scope.lastUpdatedNews = newDate;
              $scope.news = result['news']
            }
          if (newDate.getTime() > $scope.lastUpdatedNews.getTime()){
            $scope.lastUpdatedNews = newDate;
            $scope.news = result['news']
            console.log ("Changing news");
          }
        }else{
          if($scope.news.length == 0){
            $scope.news = result['news']
          }
        }
        var nextRound = moment(result['timer']['next_round']);
        if ($scope.nextRound.valueOf() != nextRound.valueOf()){
          $scope.nextRound = moment(nextRound);
          $scope.roundDuration = $scope.nextRound.diff(moment(), 'seconds')
          $scope.$broadcast('timer-set-countdown',  $scope.roundDuration);
          $scope.$broadcast('timer-start');
          $scope.$broadcast('timer-set-end-time',  $scope.roundDuration);
        }
      });
    }
    $scope.getStatus = function() {
      apiCall();
    };

    $scope.getStatus();

    $scope.updateNews = function(){
      t = $scope.news.shift();
      $scope.news.push(t);
    }
    $scope.getColor = function(value){
    //value from 0 to 1
    var hue=((1-value)*120).toString(10);
    return ["hsl(",hue,",75%,50%)"].join("");
}
    $interval(function(){$scope.updateNews()}, 8000);
    $interval(function() {
      $scope.getStatus()
    }, 3000);
  }
]);

