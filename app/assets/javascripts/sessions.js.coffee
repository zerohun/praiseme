# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  window.mySwiper = new Swiper('.swiper-container',{
    mode:'horizontal',
    keyboardControl: true,
    centeredSlides: true,
    loop: true,
    autoResize: true
  })

  $("#prev-slide").click (event)->
    if $("#presentation").css("display") != "none"
      event.preventDefault()
      window.mySwiper.swipePrev()

  $("#next-slide").click (event)->
    if $("#presentation").css("display") != "none"
      event.preventDefault()
      window.mySwiper.swipeNext()

  $("#btn-what-you-can-do").click (event)->
    $("#presentation").slideToggle()
    event.preventDefault()


  $("#wrapper").css("height", "#{$(window).height()}px" )

  $('#policy_btn').click ->
    ga('send', 'event', 'button', 'click', 'main_policy')
  
  $('#intro_btn').click ->
    ga('send', 'event', 'button', 'click', 'main_about')

$(document).ready(ready)

