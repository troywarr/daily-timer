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
      elapsed: 0
      end: 8 * config.hour
  }
  {
    name: 'Exercise (Cardio)'
    time:
      elapsed: 0
      end: 30 * config.minute
  }
  {
    name: 'Exercise (Strength Training)'
    time:
      elapsed: 0
      end: 1 * config.hour
  }
  {
    name: 'Sell Items'
    time:
      elapsed: 0
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
  _updateTime: ->
    @$elapsed.text @_getHumanTime @time.elapsed
    @$end.text @_getHumanTime @time.end

  #
  _getShortcuts: ->
    @$elapsed = @$container.find '.elapsed'
    @$end = @$container.find '.end'

  #
  start: ->
    console.log 'start'

  #
  stop: ->
    console.log 'stop'

  #
  init: ->
    @_getShortcuts()
    @_updateTime()



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
