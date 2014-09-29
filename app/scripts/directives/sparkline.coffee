'use strict'

angular.module('saStudyApp.directives')
  .directive "mySparkline", ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope,elem,attrs,ngModel) ->
      opts = {}

      opts.type = attrs.graphType || 'bar'
      opts.barColor = attrs.barColor || $(elem).css('color') || '#0000f0'
      opts.height = attrs.height || '26px'
      opts.barWidth = attrs.barWidth || '5px'
      opts.barSpacing = attrs.barSpacing || '2px'
      opts.zeroAxis = attrs.zeroAxis || 'false'

      render = () ->
        console.log('Rendering ...')
        angular.extends opts, angular.fromJson(attrs.opts) if attrs.opts

        model = ngModel.$viewValue

        if angular.isArray(model)
          data = model
        else
          if model?
            data = model.split(',')
          else
            data = []

        $(elem).sparkline(data,opts)

      scope.$watch attrs.ngModel, ((value) ->
        console.log('Watching ngModel: ' + value)
        render()
        console.log('After RENDER')
      ),true

      scope.$watch attrs.opts, ((value) ->
        console.log('Watching attrs: ' + value)
        render()
      ), true

