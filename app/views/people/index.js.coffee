$("#friends").append("<%= j render(:partial => 'people/people_list', :locals => {:users => @friends}) %>")
$(".pagination").hide()
<% if @friends.last_page? %>
$(".pagination").remove()
<% end %>
$(".pagination").replaceWith("<%= j (paginate(@friends)) %>")
