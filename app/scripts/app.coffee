'use strict'
angular
  .module('saStudyApp', [
    'ui.bootstrap',
    #'plunker',
    #'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngTouch',
    'ui.router',
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
  .config(($stateProvider,$urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'views/main.html'
      })
  )
  .run(($rootScope,settings) ->
	  settings.currentLang = settings.languages[0]; # Default language
  )
