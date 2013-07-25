$ ->
  $('.btn-more').click ->
    alert '<%= params[:id] %>'
    alert '<%= @user.user_stamps.count %>'
    #$("#stamps").append("<%=j render(:partial => 'user_stamp', :locals=>{:stamps => @user_stamps}) %>" )
    #$(".pagination").hide()
    #<% if @user_stamps.last_page? %>
    #$(".pagination").remove()
    #$(".btn-more").remove()
    #<% end %>
    #$(".pagination").replaceWith("<%= j (paginate(@user_stamps)) %>")
