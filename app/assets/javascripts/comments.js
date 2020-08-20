$(document).on('turbolinks:load', function(){
  $('form.new_comment').on('ajax:error', function(e){
    var errors = e.detail[0];
    $('.comment-errors').append(JST['templates/shared/errors'](errors));
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected() {
      this.perform('follow');
    },
    received(data) {
      var item = JST["templates/comments/comment"](data);

      if (data.commentable_type == 'Question') {
        var rowQuestionComments = $("div[class^=comment-item-]");
      
        if ($.inArray(item, rowQuestionComments) == -1)
          $('.question-comments .comments-list').prepend(item);
        $('.new_comment #comment_body').val('');
      }

      if (data.commentable_type == 'Answer') {
        var s = ".row-answer-" + data.commentable_id + ">div[class^comment-item-]"; 
        var rowAnswerComments = $(s, this); 
        
        if ($.inArray(item, rowAnswerComments) == -1)
          $('.answer-comments .comments-list').prepend(item);
        $('.row-answer-' + data.commentable_id + '>#comment_body', this).val('');
      }
    }
  })
});
