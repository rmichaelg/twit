class Lifelist.Collections.Categories extends Backbone.Collection
  model: Lifelist.Models.Category
  initialize: (params) ->
    @url = '/api/categories'
