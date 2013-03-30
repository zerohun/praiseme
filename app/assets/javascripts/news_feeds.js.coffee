# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".news-feed").click (event)->
    event.preventDefault()
    score = $(this).data("current_score")
    $("#score-gauge").find(".bar").css("width", "#{0}%")
    $("#score-gauge").modal()
    $.getJSON "/news_feeds/#{$(this).attr('id')}/get_score", (data)->
      afterScore = data["score"]
      $("#score-gauge").find(".bar").animate({width: "100%"})




$(document).ready(ready)
$(document).on('page:load', ready)
