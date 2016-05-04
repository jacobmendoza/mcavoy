(function(){
 'use strict';
  angular.module('webApp')
    .service('apiGateway', ['$http', function($http){
      var baseUrl = 'http://127.0.0.1:9494/';

      function getLatest() {
        return $http.get(baseUrl + 'latest');
      }

      function getNewsReportById(newsReportId) {
        var url = baseUrl + 'news_report/' + newsReportId;
        return $http.get(url);
      }

      function getSourceById(sourceId) {
        var url = baseUrl + 'source/' + sourceId;
        return $http.get(url);
      }

      return {
        getLatest: getLatest,
        getSourceById: getSourceById,
        getNewsReportById: getNewsReportById
      };
    }]);
})();
