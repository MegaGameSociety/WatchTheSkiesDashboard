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
        {"id": 0, "title": "Show all conversations"},
        {"id": 1, "title": "Messages waiting for my reply"},
        {"id": 2, "title": "Messages already replied to"}
      ];
      $scope.messageFilter = $scope.filterOptions[0];
    }

    $scope.messages = [];

    // A team should not be able to send messages to itself.
    $scope.validTeams = _.reject($scope.teams, function(team) {
      // A team should not be able to send messages to itself.
      if (team.id === $scope.myCountryId) {
        return team.id;
      }

      // GNN & SFT cannot message the aliens.
      if ($scope.myCountryName === 'SF&T' || $scope.myCountryName === 'GNN') {
        return team.team_name === 'Aliens1' || team.team_name === 'AliensA';
      }

      // Likewise Aliens cannot message them.
      if ($scope.myCountryName === 'Aliens1' || $scope.myCountryName === 'AliensA') {
        return team.team_name === 'GNN' || team.team_name === 'SF&T';
      }
    });

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

    // After submitting a new Message, do some updating to the view.
    $scope.pushNewMessage = function(savedMessage, conversationPartnerId) {
      var conversationPartnerId = parseInt(conversationPartnerId);

      // If there is a conversation already with this partner, grab it.
      var conversationToUpdate = _.filter($scope.messages, function(message) {
        return message.conversation_partner.id === conversationPartnerId;
      });

      if (conversationToUpdate.length > 0) {
        // Add the new message to the existing messages, update the latest.
        conversationToUpdate[0].latest_message = savedMessage;
        conversationToUpdate[0].messages.push(savedMessage);
      } else {
        // If this is a new conversation, add the new partner.
        var conversationPartner = $.grep($scope.teams, function(team) {
          return team.id == conversationPartnerId;
        });
        $scope.messages.push({
          conversation_partner: conversationPartner[0],
          latest_message: savedMessage,
          messages: [savedMessage]
        });
      }

      // Sort now that the dates have changed.
      $scope.messages = _.sortBy($scope.messages, function(conversation) {
        return conversation.latest_message.updated_at;
      }).reverse();
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

    function pushNewMessages(sortedMessages) {
      var selectedMessage = $scope.selectedMessage;

      $scope.messages = groupMessages(sortedMessages);

      // If we were selected on a conversation, let's stay selected on it.
      if (selectedMessage !== null && selectedMessage !== 'new') {
        var selectedPartner = $scope.selectedMessage.conversation_partner.id;

        var filteredConversations = _.filter($scope.messages, function(message) {
          if (message.conversation_partner.id === selectedPartner) {
            return message.conversation_partner;
          }
        });

        // Select the existing conversation
        $scope.selectConversation(filteredConversations[0]);
      }
    }

    var apiCall = function() {
      $http.get('/api/messages_data').then(
      function successCallback(response) {
        $('#connection-error').hide();
        var newMessages = response['data']['result']['messages'];

        // Get the latest message as a moment object.
        var existingMessages = $scope.messages;

        if (newMessages.length > 0) {
          var latestTimestamps = _.map(existingMessages, function(conversations) {
            return conversations.latest_message.updated_at;
          }).sort();

          // Compare existing latest with new latest.
          var latestTime = latestTimestamps.length > 0 ? moment(latestTimestamps[latestTimestamps.length - 1]) : null;

          var sortedMessages = _.sortBy(newMessages, 'updated_at')
          var newestTimestamp = moment(sortedMessages[sortedMessages.length - 1].updated_at);

          // Only update the view if there are actually new messages.
          if (latestTimestamps.length === 0 || moment(newestTimestamp).isAfter(latestTime)) {
            pushNewMessages(sortedMessages);
          }
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
