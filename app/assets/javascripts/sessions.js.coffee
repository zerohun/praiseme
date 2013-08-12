# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  $("#btn-what-you-can-do").click (event)->
    if $("i.icon-arrow-down").length > 0
      $("i.icon-arrow-down").removeClass("icon-arrow-down").addClass("icon-arrow-up")
    else
      $("i.icon-arrow-up").removeClass("icon-arrow-up").addClass("icon-arrow-down")

    $("#presentation").slideToggle()
    if typeof(window.myAboutSwiper) != "undefined"
      myAboutSwiper.destory
    if typeof(window.mySwiper) != "undefined"
      mySwiper.destroy

    window.mySwiper = new Swiper('.swiper-container',{
      mode:'horizontal',
      keyboardControl: true,
      centeredSlides: true,
      loop: false,
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
    event.preventDefault()


  $("#wrapper").css("height", "#{$(window).height()}px" )

  $('#policy_btn').click ->
    ga 'send', 'event', 'main', 'click', 'main_policy'
  
  $('#intro_btn').click ->
    ga 'send', 'event', 'main', 'click', 'main_about'

  $('.btn-sign').click ->
    ga 'send', 'event', 'main', 'click', 'main_sign_in'

$(document).ready(ready)
$(document).on('page:load', ready)

