'use strict'

Application.Services.factory 'Training', ["$resource", ($resource)->
  $resource "/api/trainings/:id",
    {id: "@id"},
    update:
      method: 'PUT'
    availabilities:
      method: 'GET'
      url: "/api/trainings/:id/availabilities"
    upcoming:
      method: 'GET'
      url: '/api/trainings/upcoming/:limit'
      params: {limit: "@limit"}
      isArray: true
]
