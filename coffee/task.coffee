define [
  './bar'
  './timer'
], (
  Bar
  Timer
) ->


  #
  class Task

    #
    constructor: (@$parentContainer, @taskData) ->
      @taskTmpl = $('#template_task').html()
      @running = false

    #
    _getShortcuts: ->
      @$time = @$container.find '.time'
      @$outerBar = @$container.find '.bar.outer'

    #
    _render: ->
      @$container = $ _.template @taskTmpl, @taskData
      @$parentContainer.append @$container

    #
    _initBar: ->
      @bar = new Bar @$outerBar
      @bar.init()

    #
    _initTimer: ->
      @timer = new Timer @$time, @bar, @taskData.time, @done
      @timer.init()

    #
    _start: ->
      @$container.addClass 'running'
      @timer.start()
      @running = true

    #
    _stop: =>
      @$container.removeClass 'running'
      @timer.stop()
      @running = false

    #
    _handleStartStop: ->
      @$container.on 'click', =>
        if @running
          @_stop()
        else
          @_start()

    #
    done: =>
      @_stop()
      @$container.off 'click'
      @$container.addClass 'done'

    #
    init: ->
      @_render()
      @_getShortcuts()
      @_initBar()
      @_initTimer()
      @_handleStartStop()
