$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('form.new_answer').on('ajax:error', function(e){
    var errors = e.detail[0];
    $('.answer-errors').append(JST['templates/shared/errors'](errors));
  })

  App.cable.subscriptions.create('AnswersChannel', {
    connected() {
      this.perform('follow');
    },
    received(data) {
     $('.answers').append(JST["templates/answer"](data));
     $('.new_answer #answer_body').val('');
    }
  })
});

