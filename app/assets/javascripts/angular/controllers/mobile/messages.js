(function() {
  // Set CSRF Headers to be used for Submitting Messages via Ajax.
  angular.module('wtsApp').config([
    "$httpProvider", function($httpProvider) {
      $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
    }
  ]);

  angular.module('wtsApp').controller('messagesCtrl', ['$scope', '$http', '$interval', function($scope, $http, $interval) {
    // Default state for Messages.
    $scope.initializeMessages = function() {
      $scope.resetMessages();

      // Message Filtering
      $scope.filterOptions = [
        {"id": 0, "title": "Show all messsages"},
        {"id": 1, "title": "Show those waiting on me"},
        {"id": 2, "title": "Show those I am waiting on"}
      ];
      $scope.messageFilter = $scope.filterOptions[0];
    }

    // Reset the new message form.
    $scope.resetNewMessage = function() {
      $scope.newMessage = {};
      $scope.message = {
        sender: null,
        content: null
      };
    }

    // Selecting conversations / new message form.
    $scope.selectConversation = function(conversation) {
      $scope.resetNewMessage();
      $scope.messageIsActive = conversation;
      $scope.selectedMessage = conversation;
    };

    $scope.createNewMessage = function() {
      $scope.resetNewMessage();
      $scope.messageIsActive = null;
      $scope.selectedMessage = 'new';
    };

    $scope.resetMessages = function() {
      $scope.resetNewMessage();
      $scope.messageIsActive = null;
      $scope.selectedMessage = null;
    };

    // Fire the request to send a message.
    $scope.sendMessage = function(message) {
      // Set us as being the one who sent the message.
      message.sender = $scope.myCountryId;

      // Error handling
      $scope.messageError = null;
      if (message.content === '' || message.content === null) {
        $scope.messageError = "You must enter a message";
        return;
      } else if (message.recipient === null) {
        $scope.messageError = "You must choose a team";
        return;
      }

      // Create the new Message object.
      $scope.newMessage = { "message": {} }
      $scope.newMessage.message = angular.copy(message);
      $scope.newMessage.message.recipient = parseInt(message.recipient);

      $http.post('/api/messages', $scope.newMessage).then(
      function successCalback(response) {
        $scope.pushNewMessage(response.data, message.recipient);
        $scope.resetNewMessage();
      },
      function errorCallback(response) {

      });
    }
    // Message Filtering
    $scope.filterFn = function(conversation) {
      var filter = $scope.messageFilter.id;

      if (filter === 0) {
        return true;
      } else if (filter === 1) {
        return conversation.latest_message.sender_id !== $scope.myCountryId;
      } else if (filter === 2) {
        return conversation.latest_message.sender_id === $scope.myCountryId;
      } else {
        return true;
      }
    };

    $scope.initializeMessages();

    // Group individual messages into Conversations.
    var groupMessages = function(messages) {
      var myCountryId = $scope.myCountryId;
      var teams = $scope.teams;

      return _.chain(messages)
      .groupBy(function(message) {
        // Group messages by who the conversation is actually with.
        return message.sender_id === myCountryId ? message.recipient_id : message.sender_id;
      })
      .map(function(messages) {
        // Get the Team name that the conversation is with.
        var conversation_partner_id = messages[0].sender_id === myCountryId ? messages[0].recipient_id : messages[0].sender_id;
        var conversation_partner = $.grep(teams, function(team){ return team.id == conversation_partner_id; });

        // Get the latest message.
        var updated = _.chain(messages)
          .sortBy(function(message) { return message.updated_at; })
          .last()
          .value()

        // Turn this array of messages into a more complex object containing all of these things.
        return {
          conversation_partner: conversation_partner[0],
          latest_message: updated,
          messages: messages
        };
      })
      .sortBy(function(messages) {
        return messages.latest_message.updated_at;
      })
      .reverse()
      .value()
    }

    var apiCall = function() {
      $http.get('/api/messages_data').then(
      function successCallback(response) {
        $('#connection-error').hide();
        var messages = response['data']['result']['messages'];
        var formattedMessages = groupMessages(messages);

        if ($scope.messages === formattedMessages) {
          // If the messages did not change, do not update them.
        } else {
          // Spoiler alert: This is broken so they re always treated as
          // having changed. I can fix it, though.
          $scope.messages = formattedMessages;
        }
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
