var item;
var i = 1;
var flag = false;
var display = function() {};

// show/hide window and change note image
$(function() {
  function display(bool) {
    if (bool) {
      $("#container").show();
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
  });
});