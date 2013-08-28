class Lifelist.Views.LandingPage extends Backbone.View
  initialize: ->
  	ClientSideValidations.remote_validators_prefix = null
  	ClientSideValidations.validators.local['email'] = (element, options) ->
      options.message unless /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i.test(element.val())
    $('#show-sign-in').leanModal()

  events:
    'ajax:success #new_invite_request': 'showThankYou'

  showThankYou: (event) ->
    $('#new_invite_request').fadeToggle 600, ->
    	$('.success-message').toggle()
