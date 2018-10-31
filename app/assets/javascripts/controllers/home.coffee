'use strict'

Application.Controllers.controller "HomeController", ['$scope', '$stateParams', 'Twitter', 'lastMembersPromise', 'lastProjectsPromise', 'upcomingEventsPromise', 'upcomingTrainingsPromise','homeBlogpostPromise', 'twitterNamePromise', 'uiCalendarConfig', 'CalendarConfig', ($scope, $stateParams, Twitter, lastMembersPromise, lastProjectsPromise, upcomingEventsPromise, upcomingTrainingsPromise, homeBlogpostPromise, twitterNamePromise, uiCalendarConfig, CalendarConfig)->

  ### PUBLIC SCOPE ###

  ## The last registered members who confirmed their addresses
  $scope.lastMembers = lastMembersPromise

  ## The last tweets from the Fablab official twitter account
  $scope.lastTweets = []

  ## The last projects published/documented on the plateform
  $scope.lastProjects = lastProjectsPromise

  ## The closest upcoming events
  $scope.upcomingEvents = upcomingEventsPromise

  ## The closest upcoming trainings
  $scope.upcomingTrainings = upcomingTrainingsPromise

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
    moment(event.start).isSame(event.end, 'day')

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

  $scope.adjustEventFields = (event) ->
    event.start = event.start_date
    event.end = event.end_date
    event.url = null
    event.colorClass = "info"
    event.containerId = "event-" + event.id
    event.type = "event"

  $scope.trainingEvents = []

  $scope.adjustTrainingFields = (event) ->
    training = {}
    training.colorClass = "success"
    training.category = {}
    training.category.name = "Workshop"
    training.title = event.name
    training.type = "training"
    training.slug = event.slug
    training.id = event.id
    for availability in event.availabilities
      training.start = availability.start_at
      training.end = availability.end_at
      training.all_day = availability.all_day
      training.containerId = "training-" + event.id + "-" + availability.id
      training.nb_total_places = availability.nb_total_places
      training.nb_free_spaces = availability.nb_free_spaces
      training.amount = availability.amount
      $scope.trainingEvents.push(Object.assign({}, training))

  $scope.adjustEventFields(event) for event in $scope.upcomingEvents
  $scope.adjustTrainingFields(event) for event in $scope.upcomingTrainings

  $scope.calendarEvents = $scope.upcomingEvents.concat($scope.trainingEvents)

  console.log($scope.calendarEvents)

  $scope.source =
    events: $scope.calendarEvents,
    backgroundColor: "transparent",
    borderColor: "transparent",
    color: "black"

  $scope.eventSources = [$scope.source]

  ### PRIVATE SCOPE ###

  calendarEventClickCb = (event, jsEvent, view) ->
    ## $state.go('app.public.events_show', {id: event.event_id})
    $scope.event = event
    modalInstance = $uibModal.open
      templateUrl: 'eventModal.html'
    return false

  ## custom event display
  eventRenderCb = (event, element) ->
    element.find('.fc-content').html($('#event-card-'+event.containerId).clone())
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
