'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('MainCtrl', function ($scope, $http, $interval, $uibModal) {
    var self = this;

    this.initialize = function() {
      self.reload();
      $interval(self.reload, 30000);
    };

    $scope.openSourceModal = function(user_id) {
      $uibModal.open({
         animation: true,
         templateUrl: 'source-modal-content.html',
         controller: 'SourceInformationModalCtrl',
         size: 'small',
         resolve: {
           source_id: function () {
             return user_id;
           }
         }
       });
    };

    this.reload = function() {
      $scope.isLoading = true;
      $http.get("http://127.0.0.1:9494/latest").success(function(result) {
        $scope.model = result;
        $scope.isLoading = false;
      }).error(function() {
          console.log("error");
          $scope.isLoading = false;
      });
    };

    this.initialize();
  });
