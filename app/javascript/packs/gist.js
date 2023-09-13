$( ".gist" ).each(function() {
    var gistId = $( this ).data('gistId');
    var linkId = $( this ).data('linkId');

    var { Octokit } = require("@octokit/core")
    var octokit = new Octokit()

    octokit.request('GET /gists/' + gistId, {
      gist_id: gistId,
      headers: {
        'X-GitHub-Api-Version': '2022-11-28'
      }
    }).then(result => addGistContentToPage(result))


    function addGistContentToPage(result){
      for (file in result.data.files) {
        var gistContent = "<h3>" + file + "</h3>"
        gistContent = gistContent + "<div>" + result.data.files[file].content + "</div>"
        gistContent = "<div class='gist-file'>" + gistContent + "</div>"
        $('#gist-' + linkId).append(gistContent)
      }
    }
  }); 
