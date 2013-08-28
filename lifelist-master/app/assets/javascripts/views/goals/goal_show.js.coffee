class Lifelist.Views.GoalShow extends Backbone.View
  events:
    'click a.btn[data-action=upvote]': 'vote'

  vote: (event) ->
    event.preventDefault()
    @current_button = $(event.currentTarget)
    @current_pathway = @current_button.closest('.pathway')
    id = @current_pathway.attr('data-id')
    @collection.get(id).save 'toggle_vote', true,
      url: Lifelist.router.goalVotePath(id)
      success: (xhr, data) =>
        @current_button.html "<i class='icon-heart'></i> #{data['votes_count']}"
