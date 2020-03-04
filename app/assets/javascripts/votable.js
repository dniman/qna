$(document).on('turbolinks:load', function(){
  var arr = ['.positive-vote', '.negative-vote', '.cancel-vote'];
  
  $.each(arr, function(index, value){
    $(document).on('ajax:success', value, function(event) {
      $(this).addClass('hidden');

      var votableId = $(this).data('votableId');
      
      if (value == arr[0]){
        $(arr[1]).each(function() {
          if ($(this).data('votableId') == votableId){
            $(this).addClass('hidden');
          }
        });
        
        $(arr[2]).each(function() {
          if ($(this).data('votableId') == votableId) {
            $(this).removeClass('hidden');
          }
        });
      }

      if (value == arr[1]){
        $(arr[0]).each(function() {
          if ($(this).data('votableId') == votableId){
            $(this).addClass('hidden');
          }
        });
        
        $(arr[2]).each(function() {
          if ($(this).data('votableId') == votableId) {
            $(this).removeClass('hidden');
          }
        });
      }

      if (value == arr[2]){
        $(arr[0]).each(function() {
          if ($(this).data('votableId') == votableId) {
            $(this).removeClass('hidden');
          }
        });
        
        $(arr[1]).each(function() {
          if ($(this).data('votableId') == votableId) {
            $(this).removeClass('hidden');
          }
        });
      }

      $('.vote-rating').each(function() {
        if ($(this).data('votableId') == votableId) {
          $(this).text(event.detail[0]["rating"]);
        }
      });
    });
  });
});
