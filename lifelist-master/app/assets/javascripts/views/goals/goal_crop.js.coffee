class Lifelist.Views.GoalCrop extends Backbone.View
  events:
    'click a.btn[data-action=start-cropping]': 'startCropping'
    'submit #crop_goal': 'afterSubmit'
    'ajax:success #crop_goal': 'finishCropping'

  startCropping: (event) ->
    event.preventDefault()
    viewer = $(event.currentTarget).parent().parent()
    cropper = viewer.next('.cropper').show()
    viewer.remove()

    version = cropper.find('img.jwindowcrop').attr('data-version')
    width = parseInt cropper.find('img.jwindowcrop').attr('data-width')
    cropper.find('img.jwindowcrop').jWindowCrop
      targetWidth: width
      targetHeight: 300
      onChange: (result) ->
        $("#goal_goal_image_attributes_#{version}_x").attr('value', result.cropX)
        $("#goal_goal_image_attributes_#{version}_y").attr('value', result.cropY)
        $("#goal_goal_image_attributes_#{version}_w").attr('value', result.cropW)
        $("#goal_goal_image_attributes_#{version}_h").attr('value', result.cropH)

  afterSubmit: (event) ->
    console.log $(event.currentTarget).find('input[type=submit]')
    @spinner = new Spinner().spin()
    event.currentTarget.appendChild(@spinner.el)

  finishCropping: (event) ->
    @spinner.stop()
    location.reload()
