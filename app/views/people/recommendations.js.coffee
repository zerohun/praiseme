$("#recommendations").html("<%=j render(:partial => "/people/recommendations", :locals => {:friends => @friends})  %>");

if $(".recommendation").length > 0
  window.clearInterval(window.interval_obj);
