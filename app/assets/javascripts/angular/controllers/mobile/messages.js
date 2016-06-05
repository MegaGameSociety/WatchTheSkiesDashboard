(function() {
  angular.module('wtsApp').controller('messagesCtrl', ['$scope', function($scope) {
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
})();
