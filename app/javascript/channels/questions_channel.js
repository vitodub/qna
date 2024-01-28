import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    if (!document.querySelector('.questions-index')) return
      
    console.log('QuestionsChannel is streaming')
    this.perform('questions_follow')

  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions-headers-list').append(data)
  }
});
