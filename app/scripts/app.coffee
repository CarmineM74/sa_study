'use strict'
angular
  .module('saStudyApp', [
    'ui.bootstrap',
    #'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngTouch',
    'ui.router',
    'ng-token-auth',
  	'app.main',
  	'app.navigation',
  	'app.localize',
  	'app.activity',
  	'app.smartui',
    'saStudyApp.directives',
    'saStudyApp.controllers'
  ])
	.factory('settings', ($rootScope) ->
		settings = {
			languages: [
				{
					language: 'Italiano',
					translation: 'Italiano',
					langCode: 'it',
					flagCode: 'it'
				},
				{
					language: 'English',
					translation: 'English',
					langCode: 'en',
					flagCode: 'us'
				}
			],
		}
		return settings
	)
  .config(($stateProvider,$urlRouterProvider,$authProvider) ->
    $authProvider.configure({
      apiUrl: '/api'
    })
    $urlRouterProvider.otherwise('/')
    $stateProvider
      .state('visitor', {
        url: '/login'
        templateUrl: 'views/login.html'
      })
      .state('home', {
        url: '/'
        templateUrl: 'views/main.html'
        data: {
          privileges: ['loggedIn']  # Upon stateChangeStart we can leverage an PermissionService passing this array
                                    # in order to check for current user's privileges before transitioning to requested state.
        }
      })
  )
  .run((settings) ->
	  settings.currentLang = settings.languages[0] # Default language
  )
  .run(($rootScope,$state,$auth) ->
    $rootScope.$on('$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      console.log('Changing state from: ' + JSON.stringify(fromState) + ' to: ' + JSON.stringify(toState))
      # This is a workaround to avoid infinite loop
      # A Better solution involves a PermissionService/AuthService
      #  - If the toState requires no privilieges, then return
      #  - If the toState requires some privileges check if current user has them and proceed accordingly
      #  The call to the service should return a promise.
      #  Idea confirmed from: https://medium.com/@mattlanham/authentication-with-angularjs-4e927af3a15f
      if (toState.name == 'visitor')
        return
      $auth.validateUser()
        .catch( ->
          $state.go('visitor')
          event.preventDefault() # Prevents transition from happening
        )
    )
    $rootScope.$on('auth:validation-error', ->
      console.log('Heading to login page!')
      $state.go('visitor')
    )
  )
