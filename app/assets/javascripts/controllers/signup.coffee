'use strict'

Application.Controllers.controller "SignUpController", ['$scope', '$state', 'Group', 'AuthService', 'Auth','CustomAsset', ($scope, $state, Group, AuthService, Auth, CustomAsset)->
 
	initialize = ->
        if $scope.isAuthenticated() 
        	$state.go('app.public.home')

        # default parameters for the date picker in the account creation modal
        $scope.datePicker =
          format: Fablab.uibDateFormat
          opened: false
          options:
            startingDay: Fablab.weekStartingDay
        #validate number format and length
        $scope.phoneNumbr = /^\+?\d{7,12}$/

        # callback to open the date picker (account creation modal)
        $scope.openDatePicker = ($event) ->
          $event.preventDefault()
          $event.stopPropagation()
          $scope.datePicker.opened = true

        # retrieve the groups (standard, student ...)
        Group.query (groups) ->
          $scope.groups = groups

        # retrieve the CGU
        CustomAsset.get {name: 'cgu-file'}, (cgu) ->
          $scope.cgu = cgu.custom_asset

        # default user's parameters
        $scope.user =
          is_allow_contact: true
          is_allow_newsletter: false

        # Errors display
        $scope.alerts = []
        $scope.closeAlert = (index) ->
          $scope.alerts.splice(index, 1)

        # callback for form validation
        $scope.ok = ->
          # try to create the account
          $scope.alerts = []
          # remove 'organization' attribute
          orga = $scope.user.organization
          delete $scope.user.organization
          # register on server
          Auth.register($scope.user).then (user) ->
            # creation successful
            $scope.setCurrentUser(user)
            $state.go('app.public.home')
          , (error) ->
            # creation failed...
            # restore organization param
            $scope.user.organization = orga
            # display errors
            # TODO: HERE MAY LAY THE CAUSE OF WEIRD ERROR DISPLAY
            angular.forEach error.data.errors, (v, k) ->
              angular.forEach v, (err) ->
                $scope.alerts.push
                  msg: k+': '+err
                  type: 'danger'    
  
     initialize()    
]