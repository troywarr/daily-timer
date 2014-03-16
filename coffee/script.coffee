# shared utilities
utils =

  #
  # see: http://stackoverflow.com/a/10073764/167911
  lPad: (item, length, padChar = '0') ->
    item += '' # convert to string
    if item.length >= length
      item
    else
      new Array(length - item.length + 1).join(padChar) + item

  # require an Underscore .tmpl file
  # see: http://stackoverflow.com/a/13029597/167911
  requireTemplate: (name) ->
    template = { name }
    template.id = "template_#{template.name}"
    template.script = $ "##{template.id}"
    if template.script.length is 0
      template.dir = './templates'
      template.url = "#{template.dir}/#{template.name}.tmpl"
      $.ajax
        url: template.url,
        method: 'GET'
        async: false
        contentType: 'text'
        success: (data) ->
          template.string = data
      $('head').append "<script id=\"#{template.id}\" type=\"text/template\">#{template.string}</script>"



# configuration
config =
  second: 1000
  minute: 60 * 1000
  hour: 60 * 60 * 1000



# default tasks
tasks = [
  {
    name: 'Mass Relevance'
    time:
      end: 8 * config.hour
  }
  {
    name: 'Exercise (Cardio)'
    time:
      end: 30 * config.minute
  }
  {
    name: 'Exercise (Strength Training)'
    time:
      end: 1 * config.hour
  }
  {
    name: 'Sell Items'
    time:
      end: 2 * config.hour
  }
]



#
class TaskList

  #
  constructor: (@$container, @tasks) ->
    @taskList = []

  #
  _insertTasks: ->
    for taskData in @tasks
      task = new Task taskData
      task.init()
      @taskList.push task
      @$container.append task.$container

  #
  init: ->
    @_insertTasks()



#
class Task

  #
  constructor: (@taskData) ->
    @taskTmpl = $('#template_task').html()
    @running = false

  #
  _getShortcuts: ->
    @$time = @$container.find '.time'
    @$outerBar = @$container.find '.bar.outer'

  #
  _render: ->
    @$container = $ _.template @taskTmpl, @taskData

  #
  _initBar: ->
    @bar = new Bar @$outerBar
    @bar.init()

  #
  _initTimer: ->
    @timer = new Timer @$time, @bar, @taskData.time
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
  init: ->
    @_render()
    @_getShortcuts()
    @_initBar()
    @_initTimer()
    @_handleStartStop()



#
class Timer

  #
  constructor: (@$container, @bar, @time) ->
    @speed = 50

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
  _updateTime: =>
    real = @counter * @speed
    @time.elapsed.current = new Date().getTime() - @time.start
    @counter++
    @_updateDisplayTime()
    diff = @time.elapsed.current - real
    @timeout = setTimeout @_updateTime, @speed - diff

  #
  _initDisplayTime: ->
    @$elapsed.text @_getHumanTime @time.elapsed.total
    @$end.text @_getHumanTime @time.end

  #
  _updateDisplayTime: ->
    @$elapsed.text @_getHumanTime @time.elapsed.total + @time.elapsed.current

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
    @counter = 0
    @time.start = new Date().getTime()
    @timeout = setTimeout @_updateTime, @speed

  #
  stop: ->
    clearTimeout @timeout
    @time.elapsed.total += @time.elapsed.current
    @time.elapsed.current = 0

  #
  init: ->
    @_getShortcuts()
    @_initTime()
    @_initDisplayTime()



#
class Bar

  #
  constructor: (@$container) ->

  #
  update: ->

  #
  init: ->



# require templates
utils.requireTemplate 'task'

# init
taskList = new TaskList $('.task-list'), tasks
taskList.init()
