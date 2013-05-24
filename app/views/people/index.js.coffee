$("#friends").append("<%= j render(@friends) %>")
<% if @friends.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@friends)) %>")
