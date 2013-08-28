class Lifelist.Collections.Steps extends Backbone.Collection
  model: Lifelist.Models.Step
  initialize: (params) ->
    @url = params.url
