$("#receivers").append("<%=j render(:partial => '/receivers/receivers', :locals => {:receivers => @receivers}) %>");
$(".pagination").hide()
<% if @receivers.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@receivers)) %>")
