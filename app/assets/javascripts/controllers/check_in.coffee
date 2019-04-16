'use strict'

Application.Controllers.controller "CheckInController", ['$scope', '$state', 'usersPromise', ($scope, $state, usersPromise )->

#
$ ->
  actualizarHora = ->
    fecha = new Date
    hora = fecha.getHours()
    minutos = fecha.getMinutes()
    segundos = fecha.getSeconds()
    diaSemana = fecha.getDay()
    dia = fecha.getDate()
    mes = fecha.getMonth()
    anio = fecha.getFullYear()
    ampm = undefined
    $pHoras = $('#horas')
    $pSegundos = $('#segundos')
    $pMinutos = $('#minutos')
    $pAMPM = $('#ampm')
    $pDiaSemana = $('#diaSemana')
    $pDia = $('#dia')
    $pMes = $('#mes')
    $pAnio = $('#anio')
    semana = [
      'Sunday'
      'Monday'
      'Thursday'
      'Wenesday'
      'Tuesday'
      'Friday'
      'Saturday'
    ]
    meses = [
      'January'
      'Febrary'
      'March'
      'April'
      'May'
      'June'
      'July'
      'Agust'
      'September'
      'October'
      'November'
      'December'
    ]
    $pDiaSemana.text semana[diaSemana]
    $pDia.text dia
    $pMes.text meses[mes]
    $pAnio.text anio
    if hora >= 12
      hora = hora - 12
      ampm = 'PM'
    else
      ampm = 'AM'
    if hora == 0
      hora = 12
    if hora < 10
      $pHoras.text '0' + hora
    else
      $pHoras.text hora
    if minutos < 10
      $pMinutos.text '0' + minutos
    else
      $pMinutos.text minutos
    if segundos < 10
      $pSegundos.text '0' + segundos
    else
      $pSegundos.text segundos
    $pAMPM.text ampm
    return

  actualizarHora()
  intervalo = setInterval(actualizarHora, 1000)
  return


  $scope.ok = ->
    # try to create the account
    $scope.alerts = []
    # register on server
    Checkin.register($scope.checkin).then (checkin) ->
      # creation successful      
      $state.go('app.public.checkinShow')
      $scope.user = userPromise
    , (error) ->
      # display errors
      # TODO: HERE MAY LAY THE CAUSE OF WEIRD ERROR DISPLAY
      angular.forEach error.data.errors, (v, k) ->
        angular.forEach v, (err) ->
          $scope.alerts.push
            msg: k+': '+err
            type: 'danger'    

]

