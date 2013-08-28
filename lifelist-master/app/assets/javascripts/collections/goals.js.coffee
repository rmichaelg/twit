class Lifelist.Collections.Goals extends Backbone.Collection
  model: Lifelist.Models.Goal
  initialize: (params) ->
    if params?
        @url = params.url
    else 
        @url = '/goals'
  comparator: (goal) ->
    -goal.id
