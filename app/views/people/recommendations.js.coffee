$("#recommendations").html("<%=j render(:partial => "/people/recommendations", :locals => {:friends => @friends})  %>");
window.clearInterval(window.interval_obj);
