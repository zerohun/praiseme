# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require bootstrap

ready = ->
  $("#wrapper").css("height", "#{$(window).height()}px" )

  $('#policy_btn').click ->
    ga 'send', 'event', 'main', 'click', 'main_policy'
  
  $('#intro_btn').click ->
    ga 'send', 'event', 'main', 'click', 'main_about'

  $('.btn-sign').click ->
    ga 'send', 'event', 'main', 'click', 'main_sign_in'

$(document).ready(ready)

