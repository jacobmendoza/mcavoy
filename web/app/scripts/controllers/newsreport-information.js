'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:SourceInformationModalCtrl
 * @description
 * # SourceInformationModalCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('NewsReportModalCtrl', function ($scope, $uibModalInstance, $http, news_report_id) {
    var self = this;

    this.initialize = function() {
      var url = "http://127.0.0.1:9494/news_report/" + news_report_id;

      $http.get(url).success(function(result) {
        $scope.model = result;
        $scope.labels = [];
        var innerList = [];
        angular.forEach(result.tweet_updates, function(value) {
          $scope.labels.push(value.retweet_count.toString());
          innerList.push(value.retweet_count);
        });
        $scope.data = [innerList];
      }).error(function() {

      });
    };

    $scope.ok = function () {
      $uibModalInstance.close();
    };

    self.initialize();
  });
