class Lifelist.Views.GoalEdit extends Backbone.View

  template: JST['goals/edit']
    
  events:
    'click #delete_goal': 'destroyGoal'

  initialize: ->
    @goals_index = Lifelist.router.goals_index
    @goal_modal = @goals_index.goal_modal
    this.bind("ok", this.okClicked)

  render: ->
    $(@el).html(@template(goal: @model, categories: Lifelist.router.categories))
    this

  destroyGoal: (event) ->
    event.preventDefault()
    @model.destroy
      wait: true
      success: =>
        $('.close').trigger('click')
        Lifelist.router.navigate('goals', {trigger: true}) #navigate away so goals_index can re-navigate back to refresh the page
      error: @handleError

  okClicked: (modal) ->
    mixpanel.track("Goal edited")
    modal.preventClose()
    attributes= name: $('#goal_name')[0].value, category_id: $('#edit_goal_category').val(), status: $('#edit_goal_status').val()
    console.log attributes
    console.log @model
    @model.save attributes,
      wait: true
      success: =>
        console.log @model
        modal.close()
      error: @handleError

  handleError: (entry, response) ->
    if response.status == 422
      errors  = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        alert "#{attribute} #{message}" for message in messages


