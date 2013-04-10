# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $("input.stamp-text-search").autocomplete
    source: "/stamps.json",
    select: (event, ui)->
      $("input[type=hidden].stamp-id").val(ui.item.id)
      $("div#reason-field").hide()
      $("div#reason-field").removeClass("hidden")
      $("div.actions").removeClass("hidden")
      $("div#reason-field").fadeIn()
      $("div#reason-field").find("textarea").focus()
      $(window).scrollTop($(window).height())

$(document).ready(ready)
$(document).on('page:load', ready)
