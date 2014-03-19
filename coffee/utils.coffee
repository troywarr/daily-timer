define [
  'jquery'
], (
  $
) ->


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

  #
  load: ->
    JSON.parse localStorage.getItem 'dailyTimer'

  #
  save: (data) ->
    localStorage.setItem 'dailyTimer', JSON.stringify data
