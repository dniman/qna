$(document).on('turbolinks:load', function(){
  $(document).on('ajax:success', function(event) {
    var data = event.detail[0];
    if (data.question) {
      $(".subscription-actions-" + data.question.id ).replaceWith(JST["templates/subscriptions/subscription"]({
        question: data.question,
        subscribed: data.subscribed
      }));
    }
  })
})

