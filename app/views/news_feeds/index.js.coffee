$("#news_feeds").append("<%= j render(@news_feeds) %>")
$(".pagination").hide()
<% if @news_feeds.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@news_feeds)) %>")
