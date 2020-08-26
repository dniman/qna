$(document).on('turbolinks:load', function(){
  $('form.new_comment').on('ajax:error', function(e){
    var errors = e.detail[0];
    $('.comment-errors').append(JST['templates/shared/errors'](errors));
  })

  const questionId = $('.question-comments').attr('data-question-id');

  App.cable.subscriptions.create( { channel: 'CommentsChannel', commentable_type: 'question', question_id: questionId }, {
    connected() {
      this.perform('follow');
    },
    received(data) {
      var item = JST["templates/comments/comment"](data);

      $('.question-comments .comments-list').prepend(item);
      $('.new_comment #comment_body').val('');
    }
  })
  
  const answerId = $('.answer-comments').attr('data-answer-id');

  App.cable.subscriptions.create( { channel: 'CommentsChannel', commentable_type: 'answer', answer_id: answerId }, {
    connected() {
      this.perform('follow');
    },
    received(data) {
      var item = JST["templates/comments/comment"](data);

      $('.answer-comments .comments-list').prepend(item);
      $('.row-answer-' + data.commentable_id + '>#comment_body', this).val('');
    }
  })
});
