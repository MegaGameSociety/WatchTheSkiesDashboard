angular.module('mobileApp', ['timer', 'truncate'])
  .controller('mobileCtrl', ['$scope', '$http', '$interval', '$window', function($scope, $http, $interval, $window) {

  // Initializations
  $scope.nextRound = new moment();
  $scope.news = [];

  // Tab changing
  $scope.focusedTab = 'news';

  $scope.setTab = function(tab) {
    $scope.focusedTab = tab;
  }

  // Some stuff shouldn't change. Eg: My Role, My Country.
  $scope.myCountry = "Germany";
  $scope.myRole = "Head of State";



  // $scope.roleColours = {
  //   'Head of State':
  // }



  // ROLE                       SCREENS                                    COLOUR
// Military                   News, Comms, Operatives, Spying            Red
// Scientist                  News, Comms, Research, Trades, Rumours     Blue
// Head of State              News, Comms, Income                        Green
// Deputy Head of State       News, Comms, Spying                        Dark Grey
// Ambassador                 News, Comms                                Purple
// Alien                      News, Comms, Operatives                    Black




  // Mock data for Messages to show the intended structure.
  $scope.myMessages = [
    {
      "id": 0,
      // These two properties are used by the Sidebar to display things in order,
      // and by who we are speaking with. Don't want to rely on the "last message"
      // sent for the name, because that might be us.
      // Eventually, conversation_partner might actually be an array of partners,
      // which will help us with displaying things in a more interesting way.
      // updated_at should be when the last message was posted.
      "conversation_partner": "Japan",
      "updated_at": '2016-03-20T16:15:00.000Z',
      "messages": [
        {
          "sender": "Japan",
          "recipient": "Germany",
          "content": "Blah blah?",
          "created_at": '2016-03-20T10:30:00.000Z'
        },
        {
          "sender": "Germany",
          "recipient": "Japan",
          "content": "Blah blah blah two. Hi we like board games.",
          "created_at": '2016-03-20T16:15:00.000Z'
        }
      ]
    },
    {
      "id": 1,
      "conversation_partner": "UK",
      "updated_at": '2016-03-20T12:29:00.000Z',
      "messages": [
        {
          "sender": "Germany",
          "recipient": "UK",
          "content": "Hi UK we miss you.",
          "created_at": '2016-03-20T08:02:00.000Z'
        },
        {
          "sender": "UK",
          "recipient": "Germany",
          "content": "Wtf mate",
          "created_at": '2016-03-20T10:41:00.000Z'
        },
        {
          "sender": "Germany",
          "recipient": "UK",
          "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt nulla vel dui vulputate, dignissim porta nisl euismod.",
          "created_at": '2016-03-20T12:29:00.000Z'
        }
      ]
    },
    {
      "id": 2,
      "conversation_partner": "USA",
      "updated_at": '2016-03-20T11:15:00.000Z',
      "messages": [
        {
          "sender": "Germany",
          "recipient": "USA",
          "content": "Hi UK we miss you.",
          "created_at": '2016-03-20T10:20:00.000Z'
        },
        {
          "sender": "USA",
          "recipient": "Germany",
          "content": "A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. ",
          "created_at": '2016-03-20T11:15:00.000Z'
        }
      ]
    },
  ];



  // API Call and Status Check Intervals.
  var apiCall = function() {
    $http.get('/api/mobile_dashboard_data').then(
      function successCallback(response) {
        // Hide the connection error if it begins working again.
        // See the Error callback for more information.
        $('#connection-error').hide();

        var result = response['data']['result'];
        $scope.terror = result['global_terror'];
        $scope.controlMessage = result['timer']['control_message'];
        $scope.round = result['timer']['round'];

        $scope.messages = result['messages'];


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

  // Phone Orientation Tracking
  $scope.getWindowOrientation = function () {
    return $window.orientation;
  };

  $scope.$watch($scope.getWindowOrientation, function (newValue, oldValue) {
    $scope.orientation = newValue === 0 ? 'portrait' : 'landscape';
  }, true);

  angular.element($window).bind('orientationchange', function () {
    $scope.$apply();
  });

  // Stuff for Messages
  $scope.messageIsActive = null;
  $scope.selectedMessage = null;

  $scope.selectConversation = function(conversation) {
    $scope.messageIsActive = conversation.id;
    $scope.selectedMessage = conversation;
  }

  $scope.createNewMessage = function() {
    $scope.messageIsActive = null;
    $scope.selectedMessage = 'new';
  }

  $scope.resetMessages = function() {
    $scope.messageIsActive = null;
    $scope.selectedMessage = null;
  }

}]);
