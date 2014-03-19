# see: https://github.com/requirejs/example-jquery-cdn
requirejs.config
  baseUrl: 'js'
  paths:
    app: 'app'
    jquery: '//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min'
    underscore: '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore-min'

requirejs ['./main'] # load the main app module to start the app
