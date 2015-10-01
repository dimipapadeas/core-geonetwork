(function() {
  goog.provide('gn_openwis_productmetadata_controller');

  var module = angular.module('gn_openwis_productmetadata_controller', []);

  module.controller('GnOpenwisProductMetadataController', [
      '$scope',
      '$routeParams',
      '$http',
      '$rootScope',
      function($scope, $routeParams, $http, $rootScope) {

        $scope.data = [];
        $scope.numResults = 20;
        $scope.position = 1;
        $scope.direction = false;

        $scope.updateData = function() {

          // TODO paginate
          $http.get(
              $scope.url + 'openwis.productmetadata.search?start='
                  + $scope.position + '&maxResults=' + $scope.numResults
                  + '&direction=' + $scope.direction).success(function(data) {
            $scope.data = data;
          }).error(function(data) {
            $rootScope.$broadcast('StatusUpdated', {
              title : 'Error',
              msg : 'Error getting user details. Please reload.',
              type : 'danger'
            });
          });
        };

        $scope.updateData();

        $scope.edit = function(element) {
          $http({
            url : $scope.url + 'openwis.productmetadata.get',
            method : 'GET',
            params : {urn: element.metadataUrn}
          }).success(function(data) {
            $scope.product = data;

            $("#editProductMetadata").modal();
          }).error(function(data) {
            console.log(data);
            $scope.updateData();
            $rootScope.$broadcast('StatusUpdated', {
              title : 'Error',
              msg : 'Error getting product metadata details. Please reload.',
              type : 'danger'
            });
          });

          //$scope.element = element;
          //$("#editProductMetadata").modal();
        };

      }
  ]);

  module.controller('GnOpenwisProductMetadataModalController', function($scope,
                                                                  $http, $rootScope) {
    $scope.ok = function() {
      $http({
        url : $scope.url + 'openwis.productmetadata.set',
        method : 'POST',
        params : $scope.product
      }).success(function(data) {
        $scope.updateData();
        $("#editProductMetadata").modal('hide');
      }).error(function(data) {
        console.log(data);
        $scope.updateData();
        $rootScope.$broadcast('StatusUpdated', {
          title : 'Error',
          msg : 'Error saving product metadadata details. Please try again.',
          type : 'danger'
        });
      });
    };

    $scope.cancel = function() {
      $("#editProductMetadata").modal('hide');
    };
  });

})();
