(function() {
  angular.module('wtsApp').controller('newsCtrl', ['$scope', function($scope) {
    $scope.hasPortraitImage = function(news_item) {
      return news_item.media_landscape == false ? 'portrait' : 'landscape'
    };
  }]);
})();
