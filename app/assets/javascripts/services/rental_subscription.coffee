'use strict'

Application.Services.factory 'RentalSubscription', ["$resource", ($resource)->
  $resource "/api/rental_subscriptions/:id",
    {id: "@id"},
    update:
      method: 'PUT'
    cancel:
      method: 'PUT'
      url: '/api/rental_subscriptions/:id/cancel'
]
