# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $("#opinion-button").click (event)->
    $("#ask-opinion-popup").modal()
    event.preventDefault()

  $("#yes-button").click (event)->
    $.post "/create_ask_opinion"
    event.preventDefault()

  if $("#recommendations").length > 0
    window.interval_obj = window.setInterval ->
      $.get "/people/recommendations", {dataType: "script"}
      ,
        3000


$(document).ready(ready)
$(document).on('page:load', ready)

