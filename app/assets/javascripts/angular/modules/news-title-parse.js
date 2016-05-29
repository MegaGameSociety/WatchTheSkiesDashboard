angular.module('parseNews', []).filter('parseTitle', function () {
  return function (input) {
    if (input.indexOf('reports') > -1) {
      return input.replace('reports:', '');
    } else {
      return input;
    }
  };
});
