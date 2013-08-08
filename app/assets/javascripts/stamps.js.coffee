# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$ ->
#  $('#search').autocomplete
#    source: "/stamp_suggestions"
ready = ->
  $(".btn-bravo").click ->
    ga 'send', 'event', 'glorify', 'click', 'glorify_button'
    ga 'send', 'event', 'glorify', 'click', 'glorify_button_stamp_page'
    

$(document).ready(ready)
$(document).on('page:load', ready)
