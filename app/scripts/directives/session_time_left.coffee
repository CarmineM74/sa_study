'use strict'
angular.module('saStudyApp.directives')
  .directive('sessionTimeLeft', ($interval,AuthorizationService) ->
    {
      restrict: 'E'
      replace: true
      template: '<div my-easy-pie data-pie-size="{{size}}" ng-model="percent" bar-color="{{color}}"><span>{{percent}}</span></div>'
      scope:
        color: '@'
        size: '@'
        sessionDuration: '@'
        refreshInterval: '@'
      controller: ($scope, $element, $attrs) ->
        #console.log('[sessionTimeLeft] Initializing ...')
        $scope.size = $scope.size || 20
        $scope.color = $scope.color || 'red'
        $scope.sessionDuration = $scope.sessionDuration || 1
        $scope.percent = 0
        refreshInterval = 1000
        refreshInterval = parseInt($scope.refreshInterval)*1000 if $scope.refreshInterval
        timer = $interval( =>
          expireAt = AuthorizationService.getExpiry()
          now = new Date()
          secondsElapsed = parseInt((expireAt-now)/1000)
          $scope.percent = 100-parseInt((secondsElapsed/$scope.sessionDuration)*100)
          #console.log('[sessionTimeLeft]: expireAt: ' + expireAt)
          #console.log('[sessionTimeLeft]: now: ' + now)
          #console.log('[sessionTimeLeft]: timer @ ' + secondsElapsed + "(" + $scope.percent + ")")
        ,refreshInterval,0)

        $scope.$on('$destroy', => $interval.cancel(timer))

    }
  )
