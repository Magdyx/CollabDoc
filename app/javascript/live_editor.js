document.addEventListener("DOMContentLoaded",function(){
    var currentRevision = 0;
    var mainArea = document.getElementById("story");
    mainArea.addEventListener("input", (event) => {
        var myJSON = JSON.stringify(buildOperation([buildInstruction(event)]));
        var formData = new FormData();
        formData.append("operation", myJSON);
        console.log(myJSON);
        var xhttp = new XMLHttpRequest();
        xhttp.open("Post", "/operations", true);
        xhttp.setRequestHeader("X-CSRF-Token", getMeta("csrf-token"));
        xhttp.send(formData);
    });

    function buildOperation (instructions) {
        var operation = {};
        operation.instructions = instructions;
        operation.document_id = mainArea.dataset.id;
        operation.revision = mainArea.dataset.revision;
        return operation;
    }
    
    function buildInstruction (event) {
        var instruction = {};
        instruction.kind = event.inputType == "insertText" ? 0 : 1;
        instruction.position = mainArea.selectionStart - (1 - instruction.kind);
        instruction.character = event.data;
        return instruction;
    }
    
});


function getMeta(metaName) {
    const metas = document.getElementsByTagName('meta');
  
    for (let i = 0; i < metas.length; i++) {
      if (metas[i].getAttribute('name') === metaName) {
        return metas[i].getAttribute('content');
      }
    }
  
    return '';
}

