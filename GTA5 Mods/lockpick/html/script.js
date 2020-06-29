var inputValue1 = document.getElementById("#input1");
var inputValue2 = document.getElementById("#input2");
var inputValue3 = document.getElementById("#input3");
var width;
var timer;
var interval;
var ref;
var item;
var i = 1;
var display = function() {};
var flag = false;
// Change focus after key press
$(document).ready(function() {
  $('input').keyup(function() {
    if ($(this).val().length == $(this).attr("maxlength")) {
      $(this).next().focus();
    }
  });
  $('input#input1').on('keyup', function() {
    inputValue1 = this.value;
    limitText(this, 1)
  });
  $('input#input2').on('keyup', function() {
    inputValue2 = this.value;
    limitText(this, 1)
  });
  $('input#input3').on('keyup', function() {
    inputValue3 = this.value;
    limitText(this, 1)
  });
  // Limit input to 1 character
  function limitText(field, maxChar) {
    ref = $(field),
      val = ref.val();
    if (val.length >= maxChar) {
      ref.val(function() {
        return val.substr(0, maxChar);
      });
    }
  }
});
function reset() {
  timer = 25;
  width = 100;
  document.getElementById("form").reset();
  $("#progress-bar").width(width + "%"); // set bar width
  flag = false;
  display(false);
}
function setTimer() {
  width = 100;
  timer = 25;
  interval = setInterval(function() {
    timer--;
    //you can access the width as a percentage pretty easily:
    width = parseInt($('#progress-bar')[0].style.width) - 3;
    //$("#progress-bar").width(width + '%'); // set bar width
    $("#progress-bar").animate({
      width: width + '%'
    }, "fast");
    if (timer <= 0) {
      clearInterval(interval); // reset timer
      $.post('http://lockpick/exit', JSON.stringify({
        close: "Time ran out"
      }));
    } else {
      $('#time').text(timer);
    }
    if (flag == false && i < 2) {
      $("#close").click(function() {
        clearInterval(interval); // reset timer
        $.post('http://lockpick/exit', JSON.stringify({
          close: "Closed"
        }));
      });
      i++;
      flag = true;
    }
    document.onkeyup = function(data) {
      if (data.which == 27) { // ESC
        clearInterval(interval); // reset timer
        $.post('http://lockpick/exit', JSON.stringify({
          close: "Escaped"
        }));
      }
    };
  }, 750);
  reset();
}
$(function() {
  function display(bool) {
    if (bool) {
      $("#container").show();
      setTimer();
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
  // Submit button
  $("#submit").click(function() {
    if (!inputValue1 || !inputValue2 || !inputValue3) {
      $.post("http://lockpick/error", JSON.stringify({
        error: "There was no value in an input field"
      }));
      reset();
      return;
    } else {
      $.post('http://lockpick/main', JSON.stringify({
        text: inputValue1 + inputValue2 + inputValue3
      }));
      reset();
      return;
    }
  });
});