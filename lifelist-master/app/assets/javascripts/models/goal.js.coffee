class Lifelist.Models.Goal extends Backbone.Model
  add_to_lifelist:->
    _this = this
    $.ajax
      url: '/goals/' + this.id + '/add_to_lifelist'
