$("#comments").prepend("<%= j render(@comments) %>")
$("#comment-pagination").html("<%= j paginate(@comments) %>")
if $('#comment-pagination .pagination a[rel=next]').length > 0
  $(".btn-more-comments").show()
else
  $(".btn-more-comments").hide()
