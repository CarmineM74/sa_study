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
          privileges: ['loggedIn']
        }
      })
  )
  .run((settings) ->
	  settings.currentLang = settings.languages[0] # Default language
  )
  .run(($rootScope,$state,$auth) ->
    console.log('Setting up auth:validation-error interception ...')
    $rootScope.$on('$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      console.log('Changing state from: ' + JSON.stringify(fromState) + ' to: ' + JSON.stringify(toState))
      if (toState.name == 'visitor')
        return
      $auth.validateUser()
        .catch( ->
          $state.go('visitor')
        )
    )
    $rootScope.$on('auth:validation-error', ->
      console.log('Heading to login page!')
      $state.go('visitor')
    )
  )
