'use strict'
angular.module('saStudyApp.services')
  .service('AuthorizationService',
    class AuthorizationService
      constructor: (@$q, @$state, @$rootScope, @$auth, @$interval) ->
        console.log('[AuthorizationService] Initializing ...')

      _user: null

      validateUser: (privileges) ->
        d = @$q.defer()
        console.log('[AuthorizationService] Validating User for privileges: ' + JSON.stringify(privileges) + '...')

    #        @$auth.validateUser()
    #          .catch((reason) =>
    #            d.reject null
    #            console.log('[AuthorizationService] User has not been VALIDATED!')
    #            @$state.go('visitor.login')
    #          )
        d.resolve('ok')

        d.promise
  )
