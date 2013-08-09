# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  window.refresh_count = 0

  $("#opinion-button").click (event)->
    $("#ask-opinion-popup").modal()
    event.preventDefault()

  $("#yes-button").click (event)->
    $.post "/create_ask_opinion"
    event.preventDefault()

  if $("#recommendations").length > 0 
    window.interval_obj = window.setInterval(->
      if $(".recommendation").length == 0 && window.refresh_count < 30
        $.get "/people/recommendations", {dataType: "script"}
        window.refresh_count = window.refresh_count + 1
    ,3000)
  else
    window.clearInterval(window.interval_obj)

  $(".recommendation").click ->
    ga 'send', 'event', 'news_feed', 'click', 'recommend'

  $('#glorify-button-bar a').click ->
    ga 'send', 'event', 'news_feed', 'click', 'main_glorify'


window.interval_obj = null
$(document).ready(ready)
$(document).on('page:load', ready)

