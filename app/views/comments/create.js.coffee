$("#last_comment_id").val("<%= @comment.id.to_s %>")
<% if @comments.present? %>
$("#comments").append("<%= j render(@comments) %>")
<% end %>

