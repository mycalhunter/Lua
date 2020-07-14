var item;
var i = 1;
var flag = false;
var display = function() {};

// close window on close button or ESC key
$(document).ready(function() {
  if (flag == false && i < 2) {
    $("#close").click(function() {
      $.post('http://notes/exit', JSON.stringify({
        close: "Closed"
      }));
    });
    i++;
    flag = true;
  }
  document.onkeyup = function(data) {
    if (data.which == 27) { // ESC
      $.post('http://notes/exit', JSON.stringify({
        close: "Escaped"
      }));
    }
  };
});

// show/hide window and change note image
$(function() {
  function display(bool) {
    if (bool) {
      $("#container").fadeIn("slow");
    } else {
      $("#container").hide();
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
    if (item.spotType == "weed") {
      $(".noteImg").css("background-image", "url('images/weed_dealer.jpg')");
    } else if (item.spotType == "cocaine") {
      $(".noteImg").css("background-image", "url('images/cocaine_dealer.jpg')");
    } else {
      $(".noteImg").css("background-image", "url('images/nothing.png')");
    }
  });
});