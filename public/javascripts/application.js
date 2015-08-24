$(document).ready(function() {

  var urlInput = $('.url-input');

  var urlResult = $('.url-result');

  var markdown = $('.markdown');

  var markdownResult = $('.markdown-result');

  var https = 'https://'
  var herokuapp = '.herokuapp.com';

  markdown.hide();

  urlInput.keyup(function(e) {
    if (e.keyCode == 13) {


      $.get("/badge/" + urlInput.val()).always(
        function(badgeUrl) {
          urlResult.attr('href', badgeUrl).attr('target', '_blank').html('See it here');
          markdown.show()
          markdownResult.html(
            '[![Heroku App Status](' + badgeUrl + ')](' + https + urlInput.val() + herokuapp + ')'
          );
        }
      ).fail(
        function() {
          urlResult.attr('href', '#').attr('target', null).html("Invalid URL");
          markdown.hide()
        }
      );
    }
  });
});
