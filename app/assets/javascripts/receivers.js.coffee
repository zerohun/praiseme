# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  $("#receivers .receiver").click ->
    ga 'send', 'event', 'glorify', 'click', 'glorify_button'
    ga 'send', 'event', 'glorify', 'click', 'glorify_select_to_reciever'



$(document).ready(ready)
$(document).on('page:load', ready)

