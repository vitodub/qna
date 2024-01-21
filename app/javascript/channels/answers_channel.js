import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    var questionId = gon.question_id
    if (!questionId) return

    console.log('AnswersChannel is streaming')
    this.perform('answers_follow', { question_id: questionId })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.user_id == gon.user_id) return

    if (data.question.user_id == gon.user_id) {
      data.question_user_eq_current_user = true
    }

    if ((gon.user_id != null) && (data.user_id != gon.user_id)) {
      data.current_user_exists_and_resource_user_not_eq_current_user = true
    }

    $('.answers').append(require("../packs/templates/answers/answer.handlebars")({ answer: data }))
  }
});



