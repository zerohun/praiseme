$("#stamp-index").append("<%= j render(:partial => 'stamp_list', :locals => {:stamps => @stamps}) %>")
<% if @stamps.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@stamps)) %>")

