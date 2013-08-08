# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.data = {}

tagOn = ->
  $("#tag-button-box").hide()
  $("#tagged-label").show()

tagOff = ->
  $("#tag-button-box").show()
  $("#tagged-label").hide()

ready = ->
  receiver_username = $("#data-bucket").data("receiver_username")
  $reasonField = $(".reason-field")
  $reasonField.highlightTextarea {words: [receiver_username]}

  if $("#compliment-form").hasClass("not-fixed") == true
    $("div#reason-field").hide()
  
  if $("#compliment-form").hasClass("fixed") == true
    $("html, body").animate({ scrollTop: $(document).height() }, "slow")

  $(".tagging-user").click (event)->
    receiver_username = $("#data-bucket").data("receiver_username")
    $reasonField.val $reasonField.val() + receiver_username
    $reasonField.highlightTextarea('highlight')
    tagOn()
    $reasonField.focus()
    event.preventDefault()


  $("input.stamp-text-search").click ->
    $(this).css("height", "60px")
    $(this).css("font-size", "30px")

  $("input.stamp-text-search").autocomplete
  #source: "/stamps.json",
    source: "/stamp_suggestions",
    select: (event, ui)->
      search_words =  $("input.stamp-text-search").val()
      con_url = "/compliments?stamp_id=#{ui.item.id}&receiver_id=#{$("#compliment_receiver_id").val()}"
      $.get con_url,
        (data) -> 
          if data.count > 0
            $("input.stamp-text-search").val(search_words)
            alert "You have already glorified him(or her) on the title"
          else  
            $("input[type=hidden].stamp-id").val(ui.item.id)
            $("div#reason-field").hide()
            $("div#reason-field").removeClass("hidden")
            $("div.actions").removeClass("hidden")
            $("div#reason-field").fadeIn()
            $("div#reason-field").find("textarea").focus()
            $("html, body").animate({ scrollTop: $("#reason-title").offset().top}, "slow")
            
            $("div.create-stamp-fields").addClass("hidden")

    ,
    response: (event, ui)->
      
      $stampTextField = $("input.stamp-text-search")
      text = $stampTextField.val()
      $create_stamp_fields = $("div.create-stamp-fields")
      $stampTextField.css("height", "30px")
      $stampTextField.css("font-size", "15px")
      #$stampTextField.val("")
      #$stampTextField.val(text)
      $(".ui-autocomplete").css("max-width", $("input.stamp-text-search").css("width"))


      if ui.content.length == 0 || (ui.content[0].label != text && text != "")
        $create_stamp_fields.removeClass("hidden")
        $create_stamp_fields.find("span.guide").text("Couldn't find #{text} stamp do you want to")
        $create_stamp_fields.find("a.create-stamp-button").text("Create #{text} glory symbol")
        $create_stamp_button = $("a.create-stamp-button")
        $("html, body").animate({ scrollTop: $("#stamp_text").offset().top}, "slow")
      else
        if ui.content[0].label == text || text == ""
          $create_stamp_fields.addClass("hidden")
          $("html, body").animate({ scrollTop: $("#create-stamp-btn").offset().top}, "slow")

    change: (event, ui)->
      $textfield = $("input.stamp-text-search")


  $(".reason-field").keyup (event)->
    receiver_username = $("#data-bucket").data("receiver_username")
    if $(this).val().search(receiver_username) == -1
      tagOff()
    else
      tagOn()



  $("input.stamp-text-search").keydown (event)->
    $(this).css("height", "60px")
    $(this).css("font-size", "30px")
    $(".ui-autocomplete").hide()
    if $(this).val() == ""
      $("div.create-stamp-fields").addClass("hidden")
    if event.which== 13
      event.preventDefault()

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
      str =  $("#comment_content").val().replace /^\s+|\s+$/g, ""
      if str.length > 0
        $("#new_comment").submit()
      e.preventDefault()
      $("#comment_content").val("")

  if $('#comment-pagination .pagination a[rel=next]').length > 0
    $(".btn-more-comments").show()
  else
    $(".btn-more-comments").hide()
  
  $(".agree-btn").click ->
    ga 'send', 'event', 'glorify', 'click', 'glorify_button'
    ga 'send', 'event', 'glorify', 'click', 'glorify_button_agree_button'

$(document).ready(ready)
$(document).on('page:load', ready)
