define ->


  #
  class Bar

    #
    constructor: (@$container) ->

    #
    _getShortcuts: ->
      @$innerBar = @$container.find '.bar.inner'

    #
    update: (percentage) ->
      @$innerBar.css 'width', "#{percentage * 100}%"

    #
    init: ->
      @_getShortcuts()
