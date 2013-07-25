$("#personal_feed").append("<%=j render(:partial => 'personal_feed', :locals=>{:feed => @personal_feed}) %>" )
$(".pagination").hide()
<% if @personal_feed.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@personal_feed)) %>")

