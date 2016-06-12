(function() {
  angular.module('wtsApp').controller('newsDesktopCtrl', ['$scope', '$interval', function($scope, $interval) {
    // Make the News Slideshow work appropriately.
    // We use "index" here to refer to the position within the News array
    // that represents the current article. It starts with the first, and
    // adjusts on a timer.
    $scope.newsIndex = 0;

    $scope.setCurrentSlideIndex = function (index) {
      $scope.newsIndex = index;
    };

    $scope.isCurrentSlideIndex = function (index) {
      return $scope.newsIndex === index;
    };

    // Update the news index every 8 seconds.
    $interval(function(){
      $scope.newsIndex = ($scope.newsIndex < $scope.news.length - 1) ? ++$scope.newsIndex : 0;
    }, 8000);
  }])
  .animation('.slide-animation', function () {
    // Animation for the news articles where each one slides up after a timer
    // and the next one takes its place. Calculate's "finished" position based
    // on the height of the news articles.
    return {
      beforeAddClass: function (element, className, done) {
        var scope = element.scope();

        if (className == 'ng-hide') {
          var finishPoint = $(element).parent().height();
          TweenMax.to(element, 0.5, {top: -finishPoint, onComplete: done });
        }
        else {
          done();
        }
      },
      removeClass: function (element, className, done) {
        var scope = element.scope();

        if (className == 'ng-hide') {
          $(element).removeClass('ng-hide');
          var startPoint = $(element).parent().height();
          TweenMax.fromTo(element, 0.5, { top: startPoint }, {top: 0, onComplete: done });
        }
        else {
          done();
        }
      }
    };
  });
})();
