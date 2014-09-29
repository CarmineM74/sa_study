'use strict'

angular.module('saStudyApp.controllers')
  .controller('LoginSignupController',
    class LoginSignupController
      constructor: (@AuthorizationService) ->
        console.log('[LoginSignupController] initializing ...')

      signup: {}
      login: {}
      user: null

      submitLogin: ->
        @AuthorizationService.login(@login)
          .then((user) =>
            @user = user
            @login = {}
          )

  )
