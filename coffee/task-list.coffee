define [
  './task'
], (
  Task
) ->


  #
  class TaskList

    #
    constructor: (@$container, @tasks) ->
      @taskList = []

    #
    _insertTasks: ->
      for taskData in @tasks
        task = new Task @$container, taskData
        task.init()
        @taskList.push task

    #
    init: ->
      @_insertTasks()
