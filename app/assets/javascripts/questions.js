$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  }) 

  $('.questions').on('ajax:success', '.positive-vote', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var questionId = $(this).data('questionId');

    $('.negative-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).addClass('hidden');
      }
    });
    
    $('.cancel-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).removeClass('hidden');
      }
    });

    $('.vote-rating').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).text(e.detail[0]);
      }
    });
  });

  $('.questions').on('ajax:success', '.negative-vote', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    
    var questionId = $(this).data('questionId');
    
    $('.positive-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).addClass('hidden');
      }
    });

    $('.cancel-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).removeClass('hidden');
      }
    });
    
    $('.vote-rating').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).text(e.detail[0]);
      }
    });
  });
  
  $('.questions').on('ajax:success', '.cancel-vote', function(e){
    e.preventDefault();
    $(this).addClass('hidden');
    
    var questionId = $(this).data('questionId');
    
    $('.positive-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).removeClass('hidden');
      }
    });

    $('.negative-vote').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).removeClass('hidden');
      }
    });
    
    $('.vote-rating').each(function() {
      if ($(this).data('questionId') == questionId) {
        $(this).text(e.detail[0]);
      }
    });
  });
});
