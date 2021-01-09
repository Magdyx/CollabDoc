import consumer from "../channels/consumer";

document.addEventListener("DOMContentLoaded", function () {
  var currentRevision = 0;
  var mainArea = document.getElementById("story");
  var documentId = mainArea.dataset.id;
  var authorId = mainArea.dataset.user_id;
  var BufferKey = "\"liveEditorBuffer\"";
  var pendingOperationKey = "";

  mainArea.addEventListener("input", (event) => {
    sendOperation(buildOperation([buildInstruction(event)]));
  });

  function buildOperation(instructions) {
    var operation = {};
    operation.instructions_attributes = instructions;
    operation.document_id = mainArea.dataset.id;
    operation.revision = mainArea.dataset.revision;
    return operation;
  }

  function buildInstruction(event) {
    var instruction = {};
    instruction.status = event.inputType == "insertText" ? 0 : 1;
    instruction.position = mainArea.selectionStart - (1 - instruction.status);
    instruction.character = event.data;
    return instruction;
  }

  function sendOperation(operation) {
    var myJSON = JSON.stringify(operation);
    var formData = new FormData();
    formData.append("operation", myJSON);
    console.log(myJSON);
    var xhttp = new XMLHttpRequest();
    xhttp.open("Post", "/operations", true);
    xhttp.setRequestHeader("X-CSRF-Token", getMeta("csrf-token"));
    xhttp.send(formData);
  }

  function insertToBuffer(instruction) {
    var instructions = JSON.parse(window.localStorage.getItem("liveEditorBuffer"));
    instructions.push(instruction);
    window.localStorage.setItem("liveEditorBuffer", JSON.stringify(instructions));
  }

  function sendInstructionsInBuffer() {
    var instructions = JSON.parse(window.localStorage.getItem("liveEditorBuffer"));
    sendOperation(buildOperation(instructions));
  }

  consumer.subscriptions.create({channel: "OperationsChannel", id: documentId}, {
    connected() {
      console.log("Connected");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
      if(data["user_id"] == authorId) {
        removePendingOperation();
      }
      sendInstructionsInBuffer();
    }
  });

  function removePendingOperation() {

  }

  function initializeBuffer() {
    window.localStorage.setItem("liveEditorBuffer", []);
  }

  function DeleteBuffer() {
    window.localStorage.removeItem(buffer)
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
