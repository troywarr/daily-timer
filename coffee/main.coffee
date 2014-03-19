define [
  './task-list'
  './utils'
  './tasks'
], (
  TaskList
  utils
  tasks
) ->


  # entry point (onDomReady)
  $ ->

    # require templates
    utils.requireTemplate 'task'

    # init
    taskList = new TaskList $('.task-list'), tasks
    taskList.init()
