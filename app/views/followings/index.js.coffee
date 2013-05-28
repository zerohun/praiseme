$("#friends").append("<%= j render(@following) %>")
<% if @following.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@following)) %>")

