$("#compliments").append("<%= j render(:partial => "/user_stamps/compliment", :collection =>  @compliments) %>")
<% if @compliments.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@compliments)) %>")

