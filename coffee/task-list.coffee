define [
  './task'
  './utils'
], (
  Task
  utils
) ->


  #
  class TaskList

    #
    constructor: (@$container, @tasks) ->
      @taskList = []

    #
    _insertTasks: ->
      loadedData = null # utils.load()
      for taskData, i in loadedData ? @tasks
        task = new Task @$container, taskData, @
        task.init()
        @taskList.push task

    #
    _autoSave: ->
      setInterval @save, 3000

    #
    save: =>
      utils.save (task.getData() for task in @taskList)

    #
    init: ->
      @_insertTasks()
      @_autoSave()
