angular.module 'flynns', []

.factory 'kimono', ($http) ->
  apikey = 'apikey=3c4b8cd526ff926daf398b6213a1a256'
  url = 'https://www.kimonolabs.com/api/266j8z8q'
  callback = 'callback=JSON_CALLBACK'
  return {
    getData: ->
      $http.jsonp "#{url}?#{apikey}&#{callback}"
  }

.controller 'the-grid', (kimono, $scope) ->
  kimono.getData().success (data) ->
    $scope.programs = data.results.collection1

  $scope.option = $('.grid--admin').css('content').replace(/\"/g,'')

.controller 'eachThumb', ($scope, $rootScope, $timeout) ->
  $scope.isopen = false

  $rootScope.$on 'toggle', (evt, idx, rowCompare) ->
    if idx is $scope.$index
      $scope.isopen = !$scope.isopen
    else
      if rowCompare isnt 0
        $scope.isopen = false
      else
        $timeout ()->
          $scope.isopen = false
          return
        , 500


.controller 'inlineClicker', ($scope, inlineService) ->
  $scope.fire = (idx) ->
    console.log 'fire'
    inlineService.toggle(idx)
    return
  return

.factory 'inlineService', ($rootScope) ->

  rowOld = null
  rowNew = null

  index = null
  gridAdmin = null

  self =
    toggle: (idx)->
      perRow = gridAdmin.css('z-index')

      if index is idx
        index = null
      else
        index = idx
        rowNew = Math.floor(idx / perRow)

      rowCompare = 0
      if rowOld isnt null and rowNew isnt null
        if rowOld < rowNew
          rowCompare = 1
        if rowOld > rowNew
          rowCompare = -1

      rowOld = rowNew

      $rootScope.$emit 'toggle', idx, rowCompare

    getIndex: ()->
      return index

    setGridAdmin: (elem)->
      gridAdmin = elem

  return self

.directive 'gridAdmin', (inlineService) ->
  link: (scope, elem) ->
    inlineService.setGridAdmin elem
