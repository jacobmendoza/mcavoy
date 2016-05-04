'use strict';

/**
 * @ngdoc function
 * @name webApp.controller:SourceInformationModalCtrl
 * @description
 * # SourceInformationModalCtrl
 * Controller of the webApp
 */
angular.module('webApp')
  .controller('NewsReportModalCtrl', function ($scope, $uibModalInstance, $http, newsReportId) {
    var self = this;

    this.initialize = function() {
      var url = 'http://127.0.0.1:9494/news_report/' + newsReportId;

      $http.get(url).success(function(result) {
        $scope.model = result;
        var lastUpdate = result.tweet_updates[result.tweet_updates.length - 1];

        if (lastUpdate.severity_levels) {
          var severity_levels = JSON.parse(lastUpdate.severity_levels);
          $scope.model.lastSeverityLabel = lastUpdate.severity_label;
          self.generateLevels(severity_levels);
        }

        $scope.chartData = self.generateChartModel(result);
      }).error(function() {

      });
    };

    this.generateLevels = function(severityLevels) {
      //TODO: This logic should not be here
      //TODO: The client should not know about the percetile of the severity levels
      $scope.model.yellowStart = Math.round(severityLevels[0.75]);
      $scope.model.orangeStart = Math.round(severityLevels[0.85]);
      $scope.model.redStart = Math.round(severityLevels[0.95]);
    };

    this.generateChartModel = function(result) {
      $scope.labels = [];
      var innerList = [];
      angular.forEach(result.tweet_updates, function(value) {
        $scope.labels.push(value.retweet_count.toString());
        innerList.push(value.retweet_count);
      });
      return [innerList];
    };

    $scope.ok = function () {
      $uibModalInstance.close();
    };

    self.initialize();
  });
