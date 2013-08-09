# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->


  $("#dash-menu li a").click (event)->
    event.preventDefault()
    $("#dash-menu li").removeClass("active")
    $(this).parent().addClass("active")

$(document).ready(ready)
$(document).on('page:load', ready)

