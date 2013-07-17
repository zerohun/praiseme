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
#= require jquery.ui.all
#= require jquery_ujs
#= require bootstrap
#= require turbolinks
#= require jquery.cookie
#= require jquery.arctext
#= require_directory .


@startLoading = ->
  $(".ajax-loader").show()
  $("#screen-container").css("opacity", 0.1)

@endLoading = ->
  $(".ajax-loader").hide()
  $("#screen-container").css("opacity", 1)

limitTextLength = (event) ->
  limittext = $(this).data('limit')
  limit = parseInt(limittext)
  length = $(this).val().length

  if $(".text-length-view").length > 0
    fieldid = $(this).attr('id')
    viewelement = $(".text-length-view[data-field=#{fieldid}]").first()
    viewelement.text "#{length}/#{limittext}"

  if limit <= length 
    textcontent = $(this).val()
    $(this).val textcontent.substr(0, limit - 1)



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
  endLoading()
  $('input[type=submit]').on 'click', (event)->
    startLoading()

  $('a').on "click", (event)->
    if $(this).attr("href") && $(this).attr("href") != "" && $(this).hasClass("no-loading") == false
      startLoading()


  $(window).on "scroll", ->
    if $('.pagination').length > 0 && $('.pagination a[rel=next]').length > 0 && $('.pagination').parent().attr("id") != "comment-pagination"
      url = $('.pagination a[rel=next]').attr('href')
      if $(window).scrollTop() > ($(document).height() - $(window).height() - 10)
        $('.pagination').show()
        $('.pagination').html('<span class="label label-darkgreen label-page-loading round border"><img src="/ajax-loader.gif" />&nbsp;&nbsp;Fetching more information</span>')
        $.getScript(url)

  adjustDeviceSize()
  #if $.cookie('need_to_check_location') == 'true'
    #navigator.geolocation.getCurrentPosition(updateLocation)


  $(".limited-text").bind "paste", limitTextLength

  $(".limited-text").keydown limitTextLength


  $(".limited-text").keydown()



$(document).ready(ready)
$(document).on('page:load', ready)
$(window).bind "unload", ->
  endLoading()

window.onload = ->
  endLoading()


$(document).on 'page:change', ->
  endLoading()



