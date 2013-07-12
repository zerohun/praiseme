$("#stamp-index").append("<%= j render(:partial => 'stamp_list', :locals => {:stamps => @stamps}) %>")
$(".pagination").hide()
<% if @stamps.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@stamps)) %>")

