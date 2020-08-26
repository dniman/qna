$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('div#edit-question-' + questionId).removeClass('hidden');
  }) 

  $('form.new_question').on('ajax:error', function(e){
    var errors = e.detail[0];
    $('.question-errors').append(JST['templates/shared/errors'](errors));
  })
  
  App.cable.subscriptions.create('QuestionsChannel', {
    connected() {
      this.perform('follow');
    },
    received(data) {
      var item = JST["templates/question"](data);
      var rowQuestions = $("div[class^=question-row-]");
      
      if ($.inArray(item, rowQuestions) == -1)
        $(item).insertBefore($('.question-errors')); 
     
      $('.new_question #question_title').val('');
      $('.new_question #question_body').val('');
    }
  })
});
