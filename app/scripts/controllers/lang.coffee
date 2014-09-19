'use strict'
angular.module('saStudyApp.controllers')
  .controller 'LangController',
    class LangController
      constructor: (@$scope, @settings, @localize) ->
        console.log('[LangController] Initializing ...')
        #console.log(JSON.stringify(@settings.languages))
        @$scope.languages = @settings.languages
        @$scope.currentLang = @settings.currentLang
        @$scope.setLang = @setLang
        # set the default language
        @setLang(@$scope.currentLang)

      setLang: (lang) =>
          @settings.currentLang = lang
          @$scope.currentLang = lang
          @localize.setLang(lang)

