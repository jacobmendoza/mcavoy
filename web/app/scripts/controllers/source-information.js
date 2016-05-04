'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:SourceInformationModalCtrl
 * @description
 * # SourceInformationModalCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('SourceInformationModalCtrl', function ($scope, $uibModalInstance, sourceId, apiGateway) {
    function initialize() {
      $scope.isLoading = true;
      apiGateway.getSourceById(sourceId).success(function(result) {
        $scope.model = result;
      }).error(function() {
          $scope.isLoading = false;
      });
    }

    $scope.ok = function () {
      $uibModalInstance.close();
    };

    initialize();
  });
