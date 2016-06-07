(function () {
  angular.module('wtsApp', ['timer', 'truncate', 'parseNews']).controller('apiCtrl', ['$scope', '$http', '$interval', '$timeout', function($scope, $http, $interval, $timeout) {

    $scope.nextRound = new moment();

    $scope.setMobile = function(status) {
      $scope.mobile = status;
    }

    $scope.initialize = function() {
      // Some stuff shouldn't change beyond a first query so we don't need to
      // check it again in the interval.
      $scope.myCountry = "Germany";
      $scope.myRole = "head";

      // Roles, Permissions, Colour Theming
      $scope.roles = {
        "ambassador": {
          name: "UN Delegate",
          colorClass: "role-ambassador",
          permissions: []
        },
        "military": {
          name: "Chief of Defense",
          colorClass: "role-military",
          permissions: ["operatives", "espionage"]
        },
        "scientist": {
          name: "Chief Scientist",
          colorClass: "role-scientist",
          permissions: ["research", "trade", "rumors"]
        },
        "head": {
          name: "Head of State",
          colorClass: "role-head",
          permissions: ["income"]
        },
        "deputy": {
          name: "Deputy Head of State",
          colorClass: "role-deputy",
          permissions: ['espionage']
        },
        "alien": {
          name: "Alien",
          colorClass: "role-alien",
          permissions: ["operatives"]
        }
      };

      $scope.getRoleName = $scope.roles[$scope.myRole].name;

      $scope.getRoleClass = function() {
        return $scope.roles[$scope.myRole].colorClass;
      }

      // Initializations
      $scope.nextRound = new moment();
      $scope.news = [];
    }

    // API Call and Status Check Intervals.
    var apiCall = function() {
      $http.get('/api/dashboard_data', $scope.mobile).then(
      function successCallback(response) {
        // Hide the connection error if it begins working again.
        // See the Error callback for more information.
        $('#connection-error').hide();

        $scope.myTeam = {
          id: 4
        }

        var result = response['data']['result'];
        $scope.terror = result['global_terror']['total'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];

        // These are only used for Desktop. Since it isn't an extra query for
        // them, I'm not bothering to filter these out.
        $scope.paused = result['timer']['paused'];
        $scope.countries = result['countries'];

        // Note: The "Vatican" class does not actually exist anywhere yet.
        $('.body').toggleClass('alien', result['alien_comms']);
        $('.Vatican').toggleClass('alien', result['vatican_alien_comms']);

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

    // This is what calls our "refresh" method to make sure we are displaying
    // the most recently set data. It currently calls an update every 3 seconds.
    $scope.getStatus = function() {
      apiCall();
    };

    $scope.initialize();
    $scope.getStatus();

    $interval(function() {
      $scope.getStatus();
    }, 3000);

  }]);
})();
