# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.data = {}
ready = ->
  $("input.stamp-text-search").autocomplete
    source: "/stamps.json",
    select: (event, ui)->
      $("input[type=hidden].stamp-id").val(ui.item.id)
      $("div#reason-field").hide()
      $("div#reason-field").removeClass("hidden")
      $("div.actions").removeClass("hidden")
      $("div#reason-field").fadeIn()
      $("div#reason-field").find("textarea").focus()
      $(window).scrollTop($(window).height())
    ,
    response: (event, ui)->
      if ui.content.length == 0
        text = $("input.stamp-text-search").val()
        if text != ""
          $create_stamp_fields = $("div.create-stamp-fields")
          $create_stamp_fields.removeClass("hidden")
          $create_stamp_fields.find("span.guide").text("Couldn't find #{text} stamp do you want to")
          $create_stamp_fields.find("a.create-stamp-button").text("Create #{text} stamp")
          $create_stamp_button = $("a.create-stamp-button")

    change: (event, ui)->
      $textfield = $("input.stamp-text-search")
      if $textfield.val() == ""
        $("div.create-stamp-fields").addClass("hidden")
    
    open: (event, ui)->
      $("div.create-stamp-fields").addClass("hidden")

  $("input.stamp-text-search").keydown ->
    if $(this).val() == ""
      $("div.create-stamp-fields").addClass("hidden")

  $("input.stamp-text-search").click ->
    $("html, body").animate({ scrollTop: $(document).height() }, "slow")

  $("a.create-stamp-button").click (event)->
    event.preventDefault()
    $("#create-stamp-popup").modal()
    #stamp_title_text = $("input.stamp-text-search").val()
    #url = $(this).attr("href") + "?stamp%5Dtitle%5d=#{stamp_title_text}"
    #$.post url, (data)->
      #stamp_id = data.id
      #endLoading()
      #$stamp_fields = $("div.stamp-fields")
      #$stamp_title = $(".stamp-title")
      #$stamp_fields.addClass "hidden"
      #$stamp_title.removeClass "hidden"
      #$stamp_title.text stamp_title_text
      
      #$("input[type=hidden].stamp-id").val(stamp_id)
      #$("div#reason-field").hide()
      #$("div#reason-field").removeClass("hidden")
      #$("div.actions").removeClass("hidden")
      #$("div#reason-field").fadeIn()
      #$("div#reason-field").find("textarea").focus()
      #$(window).scrollTop($(window).height())
    #, "json"



$(document).ready(ready)
$(document).on('page:load', ready)
