class Lifelist.Views.StepsIndex extends Backbone.View

  template: JST['steps/index']
  step_template: JST['steps/_step']
  image_embed: JST['steps/_image_embed']
  youtube_embed: JST['steps/_youtube_embed']

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @render()

  render: ->
    $(@el).html @template(steps: @collection, goal: @model)
    @renderHeader()
    @renderSteps($(@el).find('.step-list'))
    # @renderSidebar()
    @makeSortable() if editable
    this

  events:
    'submit #new_step_form': 'createStep'
    'blur #new_step_name': 'createStep'
    'click .remove': 'destroyStep'
    'click .step-status-change' : 'stepStatusUpdated'
    'click #add-to-lifelist' : 'addGoal'
    'focus .step-name' : 'startEditing'
    'keyup .step-url': 'renderEmbed'
    # todo: use data-action for all buttons
    'click [data-action]': 'doAction'
    'change .step-image-upload': 'uploadStepImage'

    'submit li.step .editor': 'saveStep'
    'blur li.step .editor': 'saveStep'

  renderHeader: ->
    @header_view = new Lifelist.Views.GoalHeader el: '#goal-name', model: @model

  renderSteps: (el) ->
    $(el).append @step_template(step: step) for step in @collection.models

  renderSidebar: ->
    sideBar = new Lifelist.Views.Sidebar(collection: @collection)
    $('#explore_pane').html(sideBar.render().el)

  createStep: (event) ->
    event.preventDefault()
    return unless editable

    step_name = $('#new_step_name').val()

    #this is to prevent the blur event creating duplicate step in case of form submit
    $('#new_step_name').val("")
    return if step_name == ""

    attributes = name: step_name
    mixpanel.track("Step added")
    @collection.create attributes,
      wait: true
      success: ->
        $('#new_step_name').focus()
      error: @handleError

  destroyStep: (event) ->
    event.preventDefault()
    return unless editable

    @target = $(event.currentTarget)
    id =  @target.closest("li.step").attr('data-id')
    mixpanel.track("Step deleted")
    if @collection.get(id).destroy()
      @target.closest("li.step").remove()

  startEditing: (event) ->
    event.preventDefault()
    return unless editable

    @target = $(event.currentTarget)
    @target.parent().parent().addClass('editing')
    @target.parent().find('.editor input[type=text]').select()

  saveStep: (event) ->
    event.preventDefault()
    return unless editable

    mixpanel.track("Step edited")
    @target = $(event.currentTarget)
    id = @target.parent().attr('data-id')
    return if !id? # default step adding form
    model = @collection.get(id)
    attributes = { name: @target.find('.step-name').val(), description: @target.find('.step-description').val(), url: @target.find('.step-url').val() }
    model.save attributes,
      error: @handleError

  handleError: (entry, response) ->
    if response.status == 422
      errors  = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        alert "#{attribute} #{message}" for message in messages

  makeSortable: ->
    $(@el).find('.sortable').sortable(handle: '.handle').on 'sortupdate', (e, ui) =>
      step = Lifelist.router.steps.get(ui.item.data('id'))
      if typeof(step.url) is 'function' # this step has not been sorted yet
        step.url = step.url()
        step.url = "#{step.url}/sort"
      step.save 'position', ui.item.parent().children('li').index(ui.item)

  stepStatusUpdated: (event) ->
    event.preventDefault()
    return unless editable

    @target = $(event.currentTarget)
    @target_step = @target.closest('li.step')
    model = @collection.get(@target_step.attr('data-id'))
    new_status = @target.context.innerHTML
    attributes = status: new_status
    @target_step.find('.current-status-name').text(new_status)
    model.save attributes,
      error: @handleError

  addGoal: (event) ->
    event.preventDefault()
    @target = $(event.currentTarget)
    goal = Lifelist.router.goals.get(@target.attr('data-id'))
    if typeof(goal.url) is 'function' # add_to_lifelist url has not yet been set
      goal.url = goal.url()
      goal.url = "#{goal.url}/add_to_lifelist"
    goal.save 'update', true
    mixpanel.track("Goal listed")
    @target.addClass('active').text('Listed!');
    # @target[0].innerHTML='Listed!'

  doAction: (event) ->
    event.preventDefault()
    @target = $(event.currentTarget)
    action = @target.attr('data-action')
    switch action
      when 'publish'
        @model.save publish: true
      when 'unpublish'
        @model.save publish: false
      when 'destroy-step-image'
        @target_step = @target.closest('.step')
        @target_editor = @target_step.find('.detail-editor')
        @target_editor.find('.fileupload').removeClass('fileupload-exists')
        @target_editor.find('.fileupload').addClass('fileupload-new')
        @target_editor.find('.step-embed').html('')

        @step = @collection.get(@target_step.attr('data-id'))
        @step.save remove_image: true

  startEditing: (event) ->
    event.preventDefault()
    @target = $(event.currentTarget)
    @target_step = @target.parent().parent()
    @target_editor = @target_step.find('.detail-editor')
    @step_embed = @target_step.find('.step-embed')

    return if $('li.step.editing')[0] == @target_step
    unless @step_embed.find('iframe, img, div').length > 0
      @step_embed.html(@getEmbedCode(@target_editor.find('.step-url').val()))
    @target_editor.find('.step-description').val "#{@collection.get(@target_step.attr('data-id')).get('description')}"
    $('li.step.editing').removeClass('editing')

    @target_step.addClass('editing')
    $('li.step:not(.editing) .detail-editor').slideUp()
    @target_editor.slideDown()

  getHostname: (url) ->
    url.replace('https://', '').replace('http://', '').replace('www.', '').split('/')[0]

  getEmbedCode: (url) ->
    hostname = @getHostname(url)
    switch hostname
      when 'youtube.com', 'youtu.be'
        url_split = url.match(/(\?v=|\&v=|\/\d\/|\/embed\/|\/v\/|\.be\/)([a-zA-Z0-9\-\_]+)/)
        if url_split?
          return @youtube_embed(video_id: url_split[2])
    return false

  renderEmbed: (event) ->
    @target = $(event.currentTarget)
    @target_step = @target.closest('.step')
    @target_editor = @target_step.find('.detail-editor')
    @step_embed = @target_editor.find('.step-embed')
    @step = @collection.get(@target_step.attr('data-id'))
    return if @previous_url == @target.val()
    @previous_url = @target.val()
    image_embed = @image_embed(name: @step.get('name'), thumbnail_url: @step.get('image').thumbnail.url) if @step.get('image').url?
    youtube_embed = @getEmbedCode(@target.val())

    @step_embed.prepend(image_embed) if image_embed?
    @step_embed.prepend(youtube_embed) if youtube_embed?

  uploadStepImage: (event) ->
    @target_step = $(event.currentTarget).closest('.step')
    @target_editor = @target_step.find('.detail-editor')
    @step_embed = @target_editor.find('.step-embed')

    @spinner = new Spinner().spin()
    @step_embed.addClass('uploading')
    @step_embed.html(@spinner.el)
    formData = new FormData()
    $input = @target_editor.find('.step-image-upload')
    formData.append "step[image]", $input[0].files[0]
    $.ajax
      url: @collection.get(@target_step.attr('data-id')).url()
      data: formData
      cache: false
      contentType: false
      processData: false
      type: "PUT"
      success: @uploadComplete

  uploadComplete: (step) =>
    @step_embed.removeClass('uploading')
    # @step_embed.find('.spinner').remove()
    @step_embed.html(@image_embed(name: step.name, thumbnail_url: step.image.thumbnail.url))
