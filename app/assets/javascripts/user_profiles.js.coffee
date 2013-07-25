# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

ready = ->
  $('.btn-more').click ->
    $('.btn-more').remove()
    page =  parseInt($('#stamps').data('page'), 10)+1
    user_id =  parseInt($('#stamps').data('user_id'), 10)
    $('#stamps').data('page',page)
    $.get '/stamp_list',
      id: user_id
      page: page
      (data) -> 
        $('#stamps').append(data)

$(document).ready(ready)
$(document).on('page:load', ready)
