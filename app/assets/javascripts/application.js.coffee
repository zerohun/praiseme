# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require bootstrap
#= require turbolinks
#= require jquery.cookie
#= require jquery.arctext
#= require_tree .

updateLocation = (position)->
  latitude = position.coords.latitude
  longitude = position.coords.longitude
  $.ajax {
         url: "/locations/update",
         type: "POST",
         data: { latitude: latitude, longitude: longitude},
         success: ->
           $.cookie('need_to_check_location', 'false')
  }



adjustDeviceSize = ->
  if $(window).width() < 767
    $("#title-menu-bar").removeClass("navbar-fixed-top").addClass("navbar-fixed-bottom")
    $("body").css("padding-top", "10px")
  else
    $("#title-menu-bar").removeClass("navbar-fixed-bottom").addClass("navbar-fixed-top")
    $("body").css("padding-top", "60px")


$(window).resize ->
  adjustDeviceSize()



ready = ->
  adjustDeviceSize()
  if $.cookie('need_to_check_location') == 'true'
    navigator.geolocation.getCurrentPosition(updateLocation)



$(document).ready(ready)
$(document).on('page:load', ready)
