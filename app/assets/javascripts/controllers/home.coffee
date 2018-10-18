'use strict'

Application.Controllers.controller "HomeController", ['$scope', '$stateParams', 'Twitter', 'lastMembersPromise', 'lastProjectsPromise', 'upcomingEventsPromise', 'homeBlogpostPromise', 'twitterNamePromise', 'uiCalendarConfig', 'CalendarConfig', ($scope, $stateParams, Twitter, lastMembersPromise, lastProjectsPromise, upcomingEventsPromise, homeBlogpostPromise, twitterNamePromise, uiCalendarConfig, CalendarConfig)->

  ### PUBLIC SCOPE ###

  ## The last registered members who confirmed their addresses
  $scope.lastMembers = lastMembersPromise

  ## The last tweets from the Fablab official twitter account
  $scope.lastTweets = []

  ## The last projects published/documented on the plateform
  $scope.lastProjects = lastProjectsPromise

  ## The closest upcoming events
  $scope.upcomingEvents = upcomingEventsPromise

  ## The admin blogpost
  $scope.homeBlogpost = homeBlogpostPromise.setting.value

  ## Twitter username
  $scope.twitterName = twitterNamePromise.setting.value

  ##
  # Test if the provided event run on a single day or not
  # @param event {Object} single event from the $scope.upcomingEvents array
  # @returns {boolean} false if the event runs on more that 1 day
  ##
  $scope.isOneDayEvent = (event) ->
    moment(event.start_date).isSame(event.end_date, 'day')

  $scope.calendarConfig = CalendarConfig
    defaultView: 'week',
    views: 
        week: 
            type: 'basic',
            duration:
              weeks: 2
    header: 
      left: '',
      center: 'title',
      right: ''
    eventRender: (event, element, view) ->
      eventRenderCb(event, element)

  $scope.trainingEvents =
    events: [],
    backgroundColor: "transparent",
    borderColor: "transparent",
    color: "black"

  $scope.workshopEvents =
    events: [],
    backgroundColor: "transparent",
    borderColor: "transparent",
    color: "black"

  $scope.adjustEventFields = (event) ->
    event.start = event.start_date
    event.end = event.end_date
    event.url = null
    if event.category.name == "Training"
      event.colorClass = "success"
      $scope.trainingEvents.events.push(event)
    else
      event.colorClass = "info"
      $scope.workshopEvents.events.push(event) 
   
  $scope.adjustEventFields(event) for event in $scope.upcomingEvents

  $scope.eventSources = [$scope.trainingEvents, $scope.workshopEvents]

  ### PRIVATE SCOPE ###

  calendarEventClickCb = (event, jsEvent, view) ->
    ## $state.go('app.public.events_show', {id: event.event_id})
    $scope.event = event
    modalInstance = $uibModal.open
      templateUrl: 'eventModal.html'
    return false

  ## custom event display
  eventRenderCb = (event, element) ->
    element.find('.fc-content').html($('#event-card-'+event.id).clone())    
    return

  ##
  # Kind of constructor: these actions will be realized first when the controller is loaded
  ##
  initialize = ->
    # we retrieve tweets from here instead of ui-router's promise because, if adblock stop the API request,
    # this prevent the whole home page to be blocked
    $scope.lastTweets =  Twitter.query(limit: 1)

    # if we recieve a token to reset the password as GET parameter, trigger the
    # changePassword modal from the parent controller
    if $stateParams.reset_password_token
      $scope.$parent.editPassword($stateParams.reset_password_token)

  ## !!! MUST BE CALLED AT THE END of the controller
  initialize()
]
