'use strict'

Application.Services.factory 'Rental', ["$resource", ($resource)->
  $resource "/api/rentals/:id",
    {id: "@id"},
    update:
      method: 'PUT'
]