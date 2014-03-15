# shared utilities
utils =

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

# require template
utils.requireTemplate 'task'
taskTmpl = $('#template_task').html()

# render template
$('.task-list').append _.template taskTmpl, { name: 'Task 1' }
