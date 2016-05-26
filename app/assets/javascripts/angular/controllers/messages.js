angular.module('messagesApp', ['truncate']).controller('messagesCtrl', ['$scope', '$element', '$window', function($scope, $element, $window) {
  $scope.myCountry = "Germany";

  // Tracking orientation of the phone.
  $scope.getWindowOrientation = function () {
    return $window.orientation;
  };

  $scope.$watch($scope.getWindowOrientation, function (newValue, oldValue) {
    $scope.orientation = newValue === 0 ? 'portrait' : 'landscape';
  }, true);

  angular.element($window).bind('orientationchange', function () {
    $scope.$apply();
  });

  // Data should be grouped by who the conversation is with.
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

  $scope.isActive = null;
  $scope.selectedMessage = null;

  $scope.selectConversation = function(conversation) {
    $scope.isActive = conversation.id;
    $scope.selectedMessage = conversation;
  }

  $scope.createNewMessage = function() {
    $scope.isActive = null;
    $scope.selectedMessage = 'new';
  }

  $scope.resetMessages = function() {
    $scope.isActive = null;
    $scope.selectedMessage = null;
  }
}]);
