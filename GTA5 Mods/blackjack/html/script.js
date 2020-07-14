var item;
var i = 1;
var flag = false;
var display = function() {};

// close window on close button or ESC key
$(document).ready(function() {
  if (flag == false && i < 2) {
    $("#close").click(function() {
      $.post('http://blackjack/exit', JSON.stringify({
        close: "Closed"
      }));
    });
    i++;
    flag = true;
  }
  document.onkeyup = function(data) {
    if (data.which == 27) { // ESC
      $.post('http://blackjack/exit', JSON.stringify({
        close: "Escaped"
      }));
    }
  };
});

// show/hide window and change note image
$(function() {
  function display(bool) {
    if (bool) {
      $("#casino").show();
    } else {
      $("#casino").hide();
    }
  }
  display(false)
  window.addEventListener('message', function(event) {
    item = event.data;
    if (item.type === "ui") {
      if (item.status == true) {
        display(true)
      } else {
        display(false)
      }
    }
    // change note based on location type
    $("#title").html(item.spotType);
    if (item.spotType == "Blackjack") {
      $(".card").css("background-image", "url('cards/AC.png')");
    } else {
      $(".card").css("background-image", "url('images/nothing.png')");
    }
  });
});