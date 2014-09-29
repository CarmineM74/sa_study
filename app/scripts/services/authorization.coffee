'use strict'
angular.module('saStudyApp.services')
  .service('AuthorizationService',
    class AuthorizationService
      constructor: (@$q, @$state, @$rootScope, @$cookieStore, @$auth, @settings, @User) ->
        console.log('[AuthorizationService] Initializing ...')

      _user: null

      setCurrentUser: (id) ->
        id = id.id
        @$cookieStore.put('user',id)
        console.log('[setCurrentUser] auth_headers: ' + JSON.stringify(@$cookieStore.get('auth_headers')))
        @User.findById(id).then((user) =>
          @_user = user
          @_user.auth_headers = @$cookieStore.get('auth_headers')
          expiry = parseInt(@_user.auth_headers.expiry,10)*1000
          expireAt = new Date()
          expireAt.setTime(expiry)
          console.log('[setCurrentUser]: Session expires at: ' + expireAt.toString())
          @$rootScope.$broadcast("user:set", @_user)
        )

      unsetCurrentUser: ->
        console.log('[unsetCurrentUser] Clearing user and cookies!')
        @_user = null
        @$cookieStore.remove('user')
        @$cookieStore.remove('auth_headers')
        @$rootScope.$broadcast("user:unset")

      currentUser: ->
        d = @$q.defer()

        @$auth.validateUser().then((validatedUser) =>
          console.log('[validateUser]: ' + JSON.stringify(validatedUser))
          d.resolve @_user
        ).catch((e) =>
          console.log("No valid authenticated user: " + JSON.stringify(e))
          @unsetCurrentUser()
        )

        d.promise

      signup: (user) ->
        d = @$q.defer()

        @$auth.submitRegistration(user)
          .then((resp) =>
            d.resolve(resp.data.data)
          )
          .catch((resp) =>
            console.log('Signup failed: ' + JSON.stringify(resp))
            @$auth.signOut()
            @unsetCurrentUser()
            d.reject(resp.data.errors)
          )

        d.promise

      login: (user) ->
        d = @$q.defer()

        @$auth.submitLogin(user).then((id) =>
          @setCurrentUser(id)
          d.resolve(@_user)
        )

        d.promise

      logout: ->
        d = @$q.defer()

        @$auth.signOut()
        @unsetCurrentUser()
        d.resolve()

        d.promise

      validateUser: (privileges) ->
        d = @$q.defer()

        @$auth.validateUser()
          .then((user) =>
            d.resolve(user)
          )
          .catch((reason) =>
            d.reject null
            @$state.go(@settings.defaultUnauthorizedState)
          )

        d.promise
  )
