import consumer from "../channels/consumer";

document.addEventListener("DOMContentLoaded", function () {
  var currentRevision = 0;
  var mainArea = document.getElementById("story");
  var documentId = mainArea.dataset.id;
  var authorId = mainArea.dataset.userId;
  var bufferKey = "liveEditorBuffer";
  var pendingOperationKey = "pendingOperation";
  removePendingOperation();
  DeleteBuffer();

  mainArea.addEventListener("input", (event) => {
    var instruction = buildInstruction(event);
    if (!isPending()) {
      sendOperation(buildOperation([instruction]));
    }
    else {
      insertToBuffer(instruction);
    }
  });

  initializeBuffer();

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
    var xhttp = new XMLHttpRequest();
    xhttp.open("Post", "/operations", true);
    xhttp.setRequestHeader("X-CSRF-Token", getMeta("csrf-token"));
    xhttp.send(formData);
    createPendingOperation(operation);
  }

  function insertToBuffer(instruction) {
    var instructions = getBuffer();
    instructions.push(instruction);
    window.localStorage.setItem(bufferKey, JSON.stringify(instructions));
  }

  function getBuffer() {
    return JSON.parse(window.localStorage.getItem(bufferKey));
  }

  function sendInstructionsInBuffer() {
    var instructions = JSON.parse(window.localStorage.getItem(bufferKey));
    if (instructions.length === 0) return;
    sendOperation(buildOperation(instructions));
    window.localStorage.setItem(bufferKey, JSON.stringify([]));
  }

  consumer.subscriptions.create({channel: "OperationsChannel", id: documentId}, {
    connected() {
      console.log("Connected");
    },

    disconnected() {
      console.log("Disconnected");
    },

    received(data) {
      if(data["user_id"] == authorId) {
        removePendingOperation();
      }
      else {
        if (!isBufferEmpty()) {
          applyTransformation(data)
        }
        updateDocument(data);
      }
      sendInstructionsInBuffer();
      updateRevision(data);
    }
  });

  function updateDocument (operation) {
    var curPos = mainArea.selectionStart;
    operation.instructions.forEach(ins => {
      if (ins.status == "ins") {
        insertAt(ins.character, ins.position);
        if (ins.position < curPos) curPos++; 
      }
      else {
        deleteAt(ins.position);
        if (ins.position < curPos) curPos--;
      }
    });
    mainArea.setSelectionRange(curPos, curPos);
  }

  function insertAt (c, pos) {
    const value = mainArea.value;
    mainArea.value = value.slice(0, pos) + c + value.slice(pos);
  }

  function deleteAt (pos) {
    const value = mainArea.value;
    mainArea.value = value.slice(0, pos) + value.slice(pos + 1);
  }

  function updateRevision (operation) {
    mainArea.dataset.revision = operation.revision;
  }

  function applyTransformation(operation) {
    getBuffer().forEach(ins => {
      operation.instructions.forEach(curr => {
        if(ins.position < curr.position) {
          if (ins.status == "del") {
            curr.position--;
          }
          else {
            curr.position++;
          }
        }
      });
    });
  }

  function isBufferEmpty() {
    return JSON.parse(window.localStorage.getItem(bufferKey)).length === 0;
  }

  function isPending () {
    return window.localStorage.getItem(pendingOperationKey) != null;
  }

  function createPendingOperation(operation) {
    window.localStorage.setItem(pendingOperationKey, JSON.stringify(operation));
  }
  
  function removePendingOperation() {
    window.localStorage.removeItem(pendingOperationKey);
  }

  function initializeBuffer() {
    window.localStorage.setItem(bufferKey, JSON.stringify([]));
  }

  function DeleteBuffer() {
    window.localStorage.removeItem(bufferKey);
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
