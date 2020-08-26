$(document).on('turbolinks:load', function(){
  $('.question-answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('div#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new_answer').on('ajax:error', function(e){
    var errors = e.detail[0];
    $('.answer-errors').append(JST['templates/shared/errors'](errors));
  })

  const questionId = $('.question-answers').attr('data-question-id');
  
  App.cable.subscriptions.create( { channel: 'AnswersChannel', 
    question_id: questionId}, {
      connected() {
        this.perform('follow');
      },
      received(data) {
        var item = JST["templates/answer"](data);
        $(item).insertBefore($('.answer-errors')); 
      
        $(document).foundation();
      
        $('.new_answer #answer_body').val('');
      }
    })
});

