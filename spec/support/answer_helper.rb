require "spec_helper"

module AnswerHelper
  def create_and_find_question
    visit questions_path
    click_link "Ask"
    page.should have_content "Step 1: Upload Videos"
    click_link "Step 2"
    page.should have_content "Step 2: Ask your question"
    fill_in "question[title]", with: "Ball starting too far left"
    fill_in "question[body]", with: "my clubface is closed..."
    expect {
      click_button "Save"
    }.to change(Question, :count).by(1) 
    page.should have_content "Question Created"
    page.should have_content "Answer question"
  end
  
  def create_answer
    click_link "Answer question"
    page.should have_selector("div", id: "new_answer")
    fill_in "answer[body]", with: "You need to shift your weight better"
    expect {
      click_button "Save Answer"
    }.to change(Answer, :count).by(1) 
    page.should have_content "You need to shift your weight better"
  end
  
  def stub_model_methods
    Answer.any_instance.stub(:toggle_question_correct).and_return(true)
    Vote.any_instance.stub(:ensure_not_author).and_return(true)
  end
end