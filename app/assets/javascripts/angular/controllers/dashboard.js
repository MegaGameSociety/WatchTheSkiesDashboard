var dashboardApp = angular.module('dashboardApp', ['dashboardController']);

var dashboardController = angular.module('dashboardController', []);

dashboardController.controller('DashboardCtrl', ['$rootScope', '$scope', '$http',
    function($rootScope, $scope, $http) {
        var apiCall = function() {
            $http.get('/api/dashboard_data').
            success(function(data, status, headers, config) {
               console.log(data);
            });
        }
        apiCall();
    }
]);