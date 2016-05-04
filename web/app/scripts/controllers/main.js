'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('MainCtrl', function ($scope, $interval, $uibModal, apiGateway) {

    function reload() {
      $scope.isLoading = true;
      apiGateway.getLatest().success(function(result) {
        $scope.model = result;
        $scope.isLoading = false;
      }).error(function() {
          $scope.isLoading = false;
      });
    }

    function initialize() {
      reload();
      $interval(self.reload, 30000);
    }

    $scope.openSourceModal = function(user_id) {
      $uibModal.open({
         animation: true,
         templateUrl: 'source-modal-content.html',
         controller: 'SourceInformationModalCtrl',
         size: '',
         resolve: {
           sourceId: function () {
             return user_id;
           }
         }
       });
    };

    $scope.openNewsReportModal = function(id) {
      $uibModal.open({
         animation: true,
         templateUrl: 'newsreport-modal-content.html',
         controller: 'NewsReportModalCtrl',
         size: 'lg',
         resolve: {
           newsReportId: function () {
             return id;
           }
         }
       });
    };

    initialize();
  });
