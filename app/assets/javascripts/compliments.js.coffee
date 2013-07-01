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
      $("div.create-stamp-fields").addClass("hidden")
    ,
    response: (event, ui)->
      text = $("input.stamp-text-search").val()
      $create_stamp_fields = $("div.create-stamp-fields")
      if ui.content.length == 0 || (ui.content[0].label != text && text != "")
        $create_stamp_fields.removeClass("hidden")
        $create_stamp_fields.find("span.guide").text("Couldn't find #{text} stamp do you want to")
        $create_stamp_fields.find("a.create-stamp-button").text("Create #{text} trophy")
        $create_stamp_button = $("a.create-stamp-button")
      else
        if ui.content[0].label == text || text == ""
          $create_stamp_fields.addClass("hidden")

    change: (event, ui)->
      $textfield = $("input.stamp-text-search")

  $("input.stamp-text-search").keydown ->
    if $(this).val() == ""
      $("div.create-stamp-fields").addClass("hidden")

  $("input.stamp-text-search").click ->
    $("html, body").animate({ scrollTop: $(document).height() }, "slow")

  $("a.create-stamp-button").click (event)->
    event.preventDefault()
    stamp_title_text = $("input.stamp-text-search").val()
    $popup = $("#create-stamp-popup")
    $popup.find(".stamp-title").text stamp_title_text 
    $("div.create-stamp-fields").addClass("hidden")
    $(".text-length-view").addClass("hidden")
    $popup.modal()

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

  $("button.default-trophy-image-select-button").click ->
    stamp_title_text = $("input.stamp-text-search").val()
    $popup = $("#create-stamp-popup")
    $popup.modal("hide")

    url = "/stamps.json"
    $.post url, {"stamp[title]": stamp_title_text, "stamp[default_trophy_image_id]": $(this).attr("id") }, (data)->
      stamp_id = data.id
      endLoading()
      $stamp_fields = $("div.stamp-fields")
      $stamp_title = $(".stamp-title")
      $stamp_fields.addClass "hidden"
      $stamp_title.removeClass "hidden"
      $stamp_title.text stamp_title_text
      
      $("input[type=hidden].stamp-id").val(stamp_id)
      $("div#reason-field").hide()
      $("div#reason-field").removeClass("hidden")
      $("div.actions").removeClass("hidden")
      $("div#reason-field").fadeIn()
      $("div#reason-field").find("textarea").focus()
      $(window).scrollTop($(window).height())
    , "json"
   
  $("#new_comment > #comment_content").keydown (e)->
    if e.keyCode == 13
      $("#new_comment").submit()
      $(this).val("")

  if $('#comment-pagination .pagination a[rel=next]').length > 0
    $(".btn-more-comments").show()
  else
    $(".btn-more-comments").hide()

$(document).ready(ready)
$(document).on('page:load', ready)
