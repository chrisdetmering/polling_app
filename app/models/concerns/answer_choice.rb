#     t.string "text", null: false
#     t.integer "question_id", null: false
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["question_id"], name: "index_answer_choices_on_question_id"


class AnswerChoice < ApplicationRecord 
  validates :text, presence: true  

  belongs_to :question, 
    primary_key: :id, 
    foreign_key: :question_id, 
    class_name: :Question 

  has_many :responses,
    primary_key: :id,
    foreign_key: :answer_choice_id, 
    class_name: :Response

end 