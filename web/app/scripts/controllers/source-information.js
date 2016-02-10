'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:SourceInformationModalCtrl
 * @description
 * # SourceInformationModalCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('SourceInformationModalCtrl', function ($scope, $uibModalInstance, $http, source_id) {
    var self = this;

    this.initialize = function() {
      $scope.isLoading = true;
      var url = "http://127.0.0.1:9494/source/" + source_id;
      $http.get(url).success(function(result) {
        $scope.model = result;
      }).error(function() {
          console.log("error");
          $scope.isLoading = false;
      });
    };

    $scope.ok = function () {
      $uibModalInstance.close();
    };

    self.initialize();
  });
