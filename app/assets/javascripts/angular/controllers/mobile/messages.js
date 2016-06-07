(function() {
  angular.module('wtsApp').controller('messagesCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
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


    // // Mock data for Messages to show the intended structure.
    // $scope.myMessages = [
    //   {
    //     "id": 0,
    //     // These two properties are used by the Sidebar to display things in order,
    //     // and by who we are speaking with. Don't want to rely on the "last message"
    //     // sent for the name, because that might be us.
    //     // Eventually, conversation_partner might actually be an array of partners,
    //     // which will help us with displaying things in a more interesting way.
    //     // updated_at should be when the last message was posted.
    //     "conversation_partner": "Japan",
    //     "updated_at": '2016-03-20T16:15:00.000Z',
    //     "messages": [
    //       {
    //         "sender": "Japan",
    //         "recipient": "Germany",
    //         "content": "Blah blah?",
    //         "created_at": '2016-03-20T10:30:00.000Z'
    //       },
    //       {
    //         "sender": "Germany",
    //         "recipient": "Japan",
    //         "content": "Blah blah blah two. Hi we like board games.",
    //         "created_at": '2016-03-20T16:15:00.000Z'
    //       }
    //     ]
    //   },
    //   {
    //     "id": 1,
    //     "conversation_partner": "UK",
    //     "updated_at": '2016-03-20T12:29:00.000Z',
    //     "messages": [
    //       {
    //         "sender": "Germany",
    //         "recipient": "UK",
    //         "content": "Hi UK we miss you.",
    //         "created_at": '2016-03-20T08:02:00.000Z'
    //       },
    //       {
    //         "sender": "UK",
    //         "recipient": "Germany",
    //         "content": "Wtf mate",
    //         "created_at": '2016-03-20T10:41:00.000Z'
    //       },
    //       {
    //         "sender": "Germany",
    //         "recipient": "UK",
    //         "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt nulla vel dui vulputate, dignissim porta nisl euismod.",
    //         "created_at": '2016-03-20T12:29:00.000Z'
    //       }
    //     ]
    //   },
    //   {
    //     "id": 2,
    //     "conversation_partner": "USA",
    //     "updated_at": '2016-03-20T11:15:00.000Z',
    //     "messages": [
    //       {
    //         "sender": "Germany",
    //         "recipient": "USA",
    //         "content": "Hi UK we miss you.",
    //         "created_at": '2016-03-20T10:20:00.000Z'
    //       },
    //       {
    //         "sender": "USA",
    //         "recipient": "Germany",
    //         "content": "A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. A boy and his dog. ",
    //         "created_at": '2016-03-20T11:15:00.000Z'
    //       }
    //     ]
    //   },
    // ];

    var apiCall = function() {
      $http.get('/api/message_data').then(
      function successCallback(response) {
        $('#connection-error').hide();

        var result = response['data']['result'];
        $scope.messages = result['messages'];
      },
      function errorCallback(response) {
        $('#connection-error').show();
      });
    }

    $scope.getMessages = function() {
      apiCall();
    };

    $scope.getMessages();

    $interval(function() {
      $scope.getMessages();
    }, 3000);
  }]);
})();
