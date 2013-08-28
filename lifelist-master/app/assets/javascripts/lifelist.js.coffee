window.Lifelist =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    @router = new Lifelist.Routers.Main
    Backbone.history.start({pushState: true})

$(document).ready ->
  Lifelist.init()
