# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require bootstrap

ready = ->
  $("#wrapper").css("height", "#{$(window).height()}px" )

$(document).ready(ready)
