# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if $('.pagination').length
    $(window).on "scroll", ->
      if $('.pagination a[rel=next]').length
        url = $('.pagination a[rel=next]').attr('href')
        if $(window).scrollTop() > ($(document).height() - $(window).height() - 10)
          $('.pagination').html('<img src="/assets/ajax-loader.gif" /><h4>Fetching more friends...</h4>')
          $.getScript(url)
