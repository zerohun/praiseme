$("#friends").append("<%= j render(@friends) %>")
$(".pagination").hide()
<% if @friends.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@friends)) %>")
