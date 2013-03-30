# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".news-feed").click (event)->
    event.preventDefault()
    score = $(this).data("exp-to-percent")
    $("#score-gauge").find(".bar").css("width", "#{score}%")
    $("#score-gauge").modal()
    $.getJSON "/news_feeds/#{$(this).attr('id')}/get_score", (data)->
      exp_percent = data["exp_to_percent"]
      $("#score-gauge").find(".bar").animate({width: "#{exp_percent}%"})





$(document).ready(ready)
$(document).on('page:load', ready)
