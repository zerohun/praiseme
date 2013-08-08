# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("#slider").evoSlider({
      mode: "scroller",                   # Sets slider mode ("accordion", "slider", or "scroller")
      width: 300,                         # The width of slider
      height: 360,                        # The height of slider
      responsive: true,
      slideSpace: 5,                      # The space between slides
  
      mouse: true,                        # Enables mousewheel scroll navigation
      keyboard: true,                     # Enables keyboard navigation (left and right arrows)
      speed: 500,                         # Slide transition speed in ms. (1s = 1000ms)
      easing: "swing",                    # Defines the easing effect mode
      loop: true,                         # Rotate slideshow
  
      autoplay: false,                    # Sets EvoSlider to play slideshow when initialized
      interval: 5000,                     # Slideshow interval time in ms
      pauseOnHover: true,                 # Pause slideshow if mouse over the slide
      pauseOnClick: true,                 # Stop slideshow if playing
      
      directionNav: true,                 # Shows directional navigation when initialized
      directionNavAutoHide: false,        # Shows directional navigation on hover and hide it when mouseout
  
      controlNav: true,                   # Enables control navigation
      controlNavAutoHide: false           # Shows control navigation on mouseover and hide it when mouseout 
  });                                

  $("#btn-what-you-can-do").click (event)->
    $("#presentation").slideToggle()
    event.preventDefault()

  $("#wrapper").css("height", "#{$(window).height()}px" )

  $('#policy_btn').click ->
    ga('send', 'event', 'button', 'click', 'main_policy')
  
  $('#intro_btn').click ->
    ga('send', 'event', 'button', 'click', 'main_about')

$(document).ready(ready)

