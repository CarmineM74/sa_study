'use strict'
angular
  .module('saStudyApp', [
    'ui.bootstrap',
    #'ngAnimate',
    'rails',
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
    'saStudyApp.resources',
    'saStudyApp.services',
    'saStudyApp.directives',
    'saStudyApp.controllers'
  ])
	.factory('settings', ($rootScope) ->
		settings = {
      defaultUnauthorizedState: 'visitor.login',
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
			]
		}
		return settings
	)
  .config(($locationProvider,$stateProvider,$urlRouterProvider,$authProvider) ->
    $authProvider.configure({
      apiUrl: '/api'
    })
    $urlRouterProvider.otherwise('/dashboard')
    $stateProvider
      .state('visitor', {
        abstract: true
        template: '<ui-view/>'
      })
      .state('visitor.login', {
        url: '/login'
        templateUrl: 'views/login.html'
        controller: 'LoginSignupController as ctrl'
      })
      .state('member', {
        abstract: true
        templateUrl: 'views/main.html'
        resolve: {
          user: (AuthorizationService) ->
            console.log('Validating user in abstract state')
            AuthorizationService.validateUser(['loggedIn'])
        }
      })
      .state('member.home', {
        url: '/dashboard'
        templateUrl: 'views/dashboard.html'
      })
  )
  .run((settings) ->
	  settings.currentLang = settings.languages[0] # Default language
  )
  .run(($rootScope, $state) ->
    $rootScope.$on('user:set', -> $state.go('member.home'))
    $rootScope.$on('user:unset', -> $state.go('visitor.login'))
  )

