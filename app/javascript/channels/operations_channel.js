import consumer from "./consumer"

document.addEventListener("DOMContentLoaded",function(){

  var mainArea = document.getElementById("story");
  var document_id = mainArea.dataset.id;

  consumer.subscriptions.create({channel: "OperationsChannel", id: document_id}, {
    connected() {
      console.log("Connected");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
    }
  });
});