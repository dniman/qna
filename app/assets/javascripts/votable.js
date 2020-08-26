$(document).on('turbolinks:load', function(){
  $(document).on('ajax:success', function(event) {
    var data = event.detail[0];
    if (data.votable) {
      $(".vote-actions-" + data.votable.id ).replaceWith(JST["templates/shared/votes"]({ 
        votable: data.votable, 
        vote: data.vote !== null ? data.vote[0] : data.vote, 
        rating: data.rating, 
        votable_root_path: data.votable.hasOwnProperty("question_id") ? 'answers': 'questions'
      }));
    }
  })
})
