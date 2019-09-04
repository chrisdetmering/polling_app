#     t.string "text", null: false
#     t.integer "poll_id", null: false
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["poll_id"], name: "index_questions_on_poll_id"

class Question < ApplicationRecord 
  validates :text, presence: true 

  belongs_to :poll, 
    primary_key: :id, 
    foreign_key: :poll_id, 
    class_name: :Poll

  has_many :answer_choices, 
    primary_key: :id, 
    foreign_key: :question_id, 
    class_name: :AnswerChoice

  has_many :responses, 
    through: :answer_choices, 
    source: :responses

  def results_by_2_queries
    answer_choices = self.answer_choices.includes(:responses)

    choice_count = {}

    answer_choices.each do |ac| 
      choice_count[ac.text] = ac.responses.length
    end 

    choice_count
  end 


  def results_by_sql 
   qrc = AnswerChoice.find_by_sql([<<-SQL, id])
      SELECT 
        answer_choices.*, COUNT(responses.id) as count
      FROM 
        answer_choices
      LEFT OUTER JOIN 
        responses 
      ON 
        responses.answer_choice_id = answer_choices.id
      WHERE 
        answer_choices.question_id = ?
      GROUP BY 
        answer_choices.id
    SQL
   
    qrc.inject({}) do |results, ac| 
      results[ac.text] = ac.count; results
    end 
  end 


  def results 
    qrc = self.answer_choices
    .select('answer_choices.*', 'COUNT(responses.id) as num_replies')
    .left_outer_joins(:responses)
    .group('answer_choices.id')

    qrc.inject({}) do |results, ac| 
      results[ac.text] = ac.num_replies; results
    end 

  end 

end 