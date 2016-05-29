var App = angular.module('mobileApp', ['timer', 'truncate', 'parseNews'])

App.controller('mobileCtrl', ['$scope', '$http', '$interval', '$window', function($scope, $http, $interval, $window) {

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

  $scope.initialize();
  $scope.getStatus();

  $interval(function() {
    $scope.getStatus();
  }, 3000);
}]);

App.controller('newsCtrl', ['$scope', function($scope) {
  $scope.hasPortraitImage = function(news_item) {
    return news_item.media_landscape == false ? 'portrait' : 'landscape'
  };
}]);

// Tab permissions and changing tabs.
App.controller('tabsCtrl', ['$scope', function($scope) {
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

// Selecting and Filtering Messages.
App.controller('messagesCtrl', ['$scope', function($scope) {
  $scope.initializeMessages = function() {
    // Default Messages State
    $scope.messageIsActive = null;
    $scope.selectedMessage = null;

    // Message Filtering
    $scope.filterOptions = [
      {"id": 0, "title": "Show all messsages"},
      {"id": 1, "title": "Show those waiting on me"},
      {"id": 2, "title": "Show those I am waiting on"}
    ];
    $scope.messageFilter = $scope.filterOptions[0];
  }

  $scope.selectConversation = function(conversation) {
    $scope.messageIsActive = conversation.id;
    $scope.selectedMessage = conversation;
  };

  $scope.createNewMessage = function() {
    $scope.messageIsActive = null;
    $scope.selectedMessage = 'new';
  };

  $scope.resetMessages = function() {
    $scope.messageIsActive = null;
    $scope.selectedMessage = null;
  };

  // Message Filtering
  $scope.filterFn = function(conversation) {
    var filter = $scope.messageFilter.id;

    if (filter === 0) {
      return true;
    } else if (filter === 1) {
      return conversation.messages[conversation.messages.length - 1].sender !== $scope.myCountry;
    } else if (filter === 2) {
      return conversation.messages[conversation.messages.length - 1].sender === $scope.myCountry;
    } else {
      return true;
    }
  };

  $scope.initializeMessages();
}]);
