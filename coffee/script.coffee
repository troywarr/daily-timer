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

  #
  getHumanTime: (time, showMS = false) ->
    ms = time % 1000
    time = parseInt (time / 1000), 0
    seconds = time % 60
    time = parseInt (time / 60), 0
    minutes = time % 60
    time = parseInt (time / 60), 0
    hours = time % 24
    output = []
    for unit in [hours, minutes, seconds]
      output.push @lPad unit, 2
    output = output.join ':'
    if ms? and showMS
      output += ".#{@lPad ms, 3}"
    output

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
  constructor: (@tasks) ->
    utils.requireTemplate 'task'
    @taskTmpl = $('#template_task').html()
    # shortcuts
    @$taskList = $ '.task-list'

  #
  _insertTasks: ->
    for task in @tasks
      $taskListItem = $ _.template @taskTmpl, task
      @$taskList.append $taskListItem
      $elapsed = $taskListItem.find '.elapsed'
      $end = $taskListItem.find '.end'
      $elapsed.text utils.getHumanTime task.time.elapsed
      $end.text utils.getHumanTime task.time.end

  init: ->
    @_insertTasks()



#
class TaskListItem

  constructor: ->



#
class Timer

  constructor: ->



timerList = new TaskList tasks
timerList.init()
