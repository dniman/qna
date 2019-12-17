$(function() {
  $('.bounty').on('cocoon:after-insert', function() {
    check_to_hide_or_show_add_link();
  });

  $('.bounty').on('cocoon:after-remove', function() {
    check_to_hide_or_show_add_link();
  });

  check_to_hide_or_show_add_link();

  function check_to_hide_or_show_add_link() {
    if ($('.bounty-fields').length == 1) {
      $('.bounty .add_fields').hide();
    } else {
      $('.bounty .add_fields').show();
    }
  }
})

