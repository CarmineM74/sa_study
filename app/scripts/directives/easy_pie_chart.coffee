'use strict'

angular.module('saStudyApp.directives')
  .directive 'myEasyPie', ($parse) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope,elem,attrs,ngModel) ->
      opts = {}
      if attrs.barColorCb
        barColorHandler = $parse(attrs.barColorCb)
        opts.barColor = (value) -> barColorHandler(scope,{value:value[0]})
      else
        opts.barColor = attrs.barColor || $(elem).css('color') || '#0000f0'
      opts.trackColor = attrs.trackColor || '#eeeeee'
      opts.size = 25
      opts.size = parseInt(attrs.pieSize) if attrs.pieSize
      opts.scaleColor = attrs.scaleColor || false
      opts.lineCap = attrs.lineCap || 'butt'
      opts.animate = 1500
      opts.animate = parseInt(attrs.animate) if attrs.animate
      opts.rotate = -90
      opts.rotate = parseInt(attrs.rotate) if attrs.rotate

      if attrs.onStep
        onStepHandler = $parse(attrs.onStep)
        opts.onStep = (value) -> onStepHandler(scope,{value:value[0]})

      angular.extends opts, angular.fromJson(attrs.opts) if attrs.opts
      $(elem).easyPieChart(opts)

      scope.$watch attrs.ngModel, ((value) ->
#        console.log("ngModel changed:" + value)
        render()
      ),true

      scope.$watch attrs.opts, ((value) ->
#        console.log(" opts changed:" + value)
        render()
      ),true

      render = () ->
        angular.extends opts, angular.fromJson(attrs.opts) if attrs.opts
        model = ngModel.$viewValue
#        console.log('Rendering: ' + model + ' opts: ' + JSON.stringify(opts))
        $(elem).data('easyPieChart').update(parseInt(model))





