'use strict'
angular.module('saStudyApp.directives')
  .directive('logoutButton', (AuthorizationService)->
    {
      restrict: 'E'
      replace: true
      template: '<div>' +
                  '<span logout title="Logout"></span>' +
					        '<span><a href="/" title="Sign Out"><i class="fa fa-sign-out"></i></a></span>' +
				          '</div>'
      controllerAs: 'ctrl'
      controller: ($scope, $element, $attrs) ->
        logout: ->
          AuthorizationService.currentUser().then((user) ->
            angular.element.SmartMessageBox(
              {
                title: "<i class='fa fa-sign-out txt-color-orangeDark'></i> Logout <span class='txt-color-orangeDark'><strong>" + user.email + "</strong></span> ?"
                content: $attrs.logoutMsg || "You can improve your security further after logging out by closing this opened browser"
                buttons: '[No][Yes]'
              },
              (ButtonPressed) =>
                if (ButtonPressed == "Yes")
                  setTimeout(AuthorizationService.logout(), 1000)
             )
            )
    }
  )

