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
        resolve: {
          auth: ($auth) ->
            console.log('Checking for authorization before heading home ...')
            $auth.validateUser()
              .then(-> console.log('Sir, you have permission granted.'))
        }
      })
  )
  .run((settings) ->
	  settings.currentLang = settings.languages[0] # Default language
  )
  .run(($rootScope,$state) ->
    console.log('Setting up auth:validation-error interception ...')
    $rootScope.$on('event:unauthorized', ->
      console.log('Heading to login page!')
      $state.go('login')
    )
  )
