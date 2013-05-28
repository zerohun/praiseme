$("#friends").append("<%= j render(@users) %>")
<% if @users.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@users)) %>")
