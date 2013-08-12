# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  if $("#about").length > 0
    if typeof(window.mySwiper) != "undefined"
      window.mySwiper.destroy

    if typeof(window.myAboutSwiper) != "undefined"
      window.myAboutSwiper.destroy


    window.myAboutSwiper = new Swiper('.swiper-container',{
      mode:'horizontal',
      keyboardControl: true,
      centeredSlides: true,
      loop: false,
      autoResize: true
    })

    $("#prev-slide").click (event)->
      if $("#presentation").css("display") != "none"
        event.preventDefault()
        window.myAboutSwiper.swipePrev()

    $("#next-slide").click (event)->
      if $("#presentation").css("display") != "none"
        event.preventDefault()
        window.myAboutSwiper.swipeNext()

$(document).ready(ready)
$(document).on('page:load', ready)
