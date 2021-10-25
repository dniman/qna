$(document).on('turbolinks:load', function(){
  $(document).on('ajax:success', function(event) {
    var data = event.detail[0];
    if (data.subscriptionable) {
      $(".subscription-actions-" + data.subscriptionable.id ).replaceWith(JST["templates/shared/subscriptions"]({
        subscriptionable: data.subscriptionable,
        subscriptionable_root_path: 'questions',
        subscribed: data.subscribed
      }));
    }
  })
})

