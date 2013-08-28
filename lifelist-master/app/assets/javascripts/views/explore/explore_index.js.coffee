class Lifelist.Views.ExploreIndex extends Backbone.View

  initialize: ->
    @collection.on('reset', @defaultButtonStates())

  defaultButtonStates: ->
    for goal in @collection.models
      if goals_listed.indexOf(goal.get("id"))>=0
        $("a.add-goal[data-id='#{goal.get("id")}']").addClass('active')
      if goals_done.indexOf(goal.get("id"))>=0
        $("a.done-it[data-id='#{goal.get("id")}']").addClass('active')

  events:
    'click a.add-goal': 'addGoal'
    'click a.done-it': 'doneIt'

  addGoal: (event) ->
    event.preventDefault()
    @target = $(event.currentTarget)
    id = @target.attr('data-id')
    goal = @collection.get(id)
    goal.save 'update', true,
      url: "#{Lifelist.router.goalPath(id)}/add_to_lifelist"
    mixpanel.track("Goal listed")
    @target.addClass('active')

  doneIt: (event) ->
    event.preventDefault()
    @target = $(event.currentTarget)
    id = @target.attr('data-id')
    goal = @collection.get(id)
    goal.save 'update', true,
      url: "#{Lifelist.router.goalPath(id)}/add_to_doneit"
    mixpanel.track("Done It listed")
    @target.addClass('active')
