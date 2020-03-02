$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answers').on('ajax:success', '.positive-vote', function(e){
    e.preventDefault();
    $(this).addClass('hidden');
    
    var answerId = $(this).data('answerId');
    
    $('.negative-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).addClass('hidden');
      }
    });

    $('.cancel-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).removeClass('hidden');
      }
    });

    $('.vote-rating').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).text(e.detail[0]);
      }
    });
  });
  
  $('.answers').on('ajax:success', '.negative-vote', function(e){
    e.preventDefault();
    $(this).addClass('hidden');
    
    var answerId = $(this).data('answerId');
    
    $('.positive-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).addClass('hidden');
      }
    });

    $('.cancel-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).removeClass('hidden');
      }
    });
    
    $('.vote-rating').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).text(e.detail[0]);
      }
    });
  });
  
  $('.answers').on('ajax:success', '.cancel-vote', function(e){
    e.preventDefault();
    $(this).addClass('hidden');
    
    var answerId = $(this).data('answerId');
    
    $('.positive-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).removeClass('hidden');
      }
    });

    $('.negative-vote').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).removeClass('hidden');
      }
    });
    
    $('.vote-rating').each(function() {
      if ($(this).data('answerId') === answerId) {
        $(this).text(e.detail[0]);
      }
    });
  });
});

