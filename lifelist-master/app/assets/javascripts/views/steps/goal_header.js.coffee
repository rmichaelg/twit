class Lifelist.Views.GoalHeader extends Backbone.View
  template: JST['steps/goal_header']

  initialize: ->
    @model.on('change', @render, this)
    @render()

  render: ->
    $(@el).html(@template(goal: @model))
    $('time.timeago').timeago()
    this

  events:
    'change #goal-image-upload': 'uploadGoalImage'

  uploadGoalImage: (event) ->
    @goal_banner = $(event.currentTarget).closest('.goal-banner')
    @explore_image = @goal_banner.find('.explore_image')

    @spinner = new Spinner().spin()
    @goal_banner.addClass('uploading')
    @explore_image.css('background-image', 'none')
    @explore_image.append(@spinner.el)
    formData = new FormData()
    $input = $("#goal-image-upload")
    formData.append "goal[goal_image_attributes][image]", $input[0].files[0]
    $.ajax
      url: @model.url()
      data: formData
      cache: false
      contentType: false
      processData: false
      type: "PUT"
      success: @uploadComplete

  uploadComplete: (goal) =>
    @goal_banner.removeClass('uploading')
    @explore_image.find('.spinner').remove()
    @explore_image.css('background-image', "url(#{goal['feature_image_url']})")
