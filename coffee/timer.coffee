define [
  './utils'
], (
  utils
) ->


  #
  class Timer

    #
    constructor: (@$container, @bar, @time, @doneCallback) ->
      @speed = 100
      @finished = false

    #
    _getHumanTime: (time, showMS = false) ->
      ms = time % 1000
      time = parseInt (time / 1000), 0
      seconds = time % 60
      time = parseInt (time / 60), 0
      minutes = time % 60
      time = parseInt (time / 60), 0
      hours = time % 24
      output = []
      for unit in [hours, minutes, seconds]
        output.push utils.lPad unit, 2
      output = output.join ':'
      if ms? and showMS
        output += ".#{utils.lPad ms, 3}"
      output

    #
    # see: http://www.sitepoint.com/creating-accurate-timers-in-javascript/
    _update: =>
      real = @counter * @speed
      @time.elapsed.current = new Date().getTime() - @time.start
      if @time.elapsed.total + @time.elapsed.current >= @time.end # if we've finished
        @finished = true
        @stop()
        @doneCallback()
      else # still going
        @counter++
        @_updateDisplay()
        @timeout = setTimeout @_update, @speed - (@time.elapsed.current - real)

    #
    _initDisplayTime: ->
      @$elapsed.text @_getHumanTime @time.elapsed.total
      @$end.text @_getHumanTime @time.end

    #
    _updateDisplay: ->
      runningTime = @time.elapsed.total + @time.elapsed.current
      @$elapsed.text @_getHumanTime runningTime # update timer
      @bar.update runningTime / @time.end # update bar

    #
    _getShortcuts: ->
      @$elapsed = @$container.find '.elapsed'
      @$end = @$container.find '.end'

    #
    _initTime: ->
      @time.elapsed =
        total: 0
        current: 0

    #
    start: ->
      if not @finished
        @counter = 0
        @time.start = new Date().getTime()
        @timeout = setTimeout @_update, @speed

    #
    stop: ->
      clearTimeout @timeout
      @time.elapsed.total += @time.elapsed.current
      @time.elapsed.current = 0
      @_updateDisplay()

    #
    init: ->
      @_getShortcuts()
      @_initTime()
      @_initDisplayTime()
