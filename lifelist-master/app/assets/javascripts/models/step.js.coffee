class Lifelist.Models.Step extends Backbone.Model
  goal_model: ->
    new Lifelist.Models.Goal(this.get("goal")) #only present when coming from the API (new baclbone objects don't have it)