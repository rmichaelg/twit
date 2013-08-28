class Lifelist.Views.Sidebar extends Backbone.View
  template: JST['steps/sidebar']

  initialize: ->
    @steps=[]
    for step in @collection.models
      if step.get('completed')
        @steps.push 1
      else
        @steps.push 0
        
  pct_completed: ->
    if @steps.length > 0
      ((@steps.reduce (x, y) -> x + y) / @steps.length) * 100
    else
      null

  render: ->
      $(@el).html(@template(pct_completed: this.pct_completed()))
      this