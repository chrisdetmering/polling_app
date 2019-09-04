class Response < ApplicationRecord 
  validate :not_duplicate_response
  validate :no_author_replies
  
  belongs_to :answer_choice, 
    primary_key: :id, 
    foreign_key: :answer_choice_id,
    class_name: :AnswerChoice 

  belongs_to :respondent, 
    primary_key: :id, 
    foreign_key: :respondent_id,
    class_name: :User

  has_one :question, 
    through: :answer_choice, 
    source: :question


  def no_author_replies
    if author_reply?
      errors[:author] << 'can\'t reply to own poll' 
    end
  end 

  def author_reply? 
    self.question.poll.author.id == self.respondent_id
  end 

  def not_duplicate_response 
   if respondent_already_answered?
    errors[:replies] << 'too many for the given user' 
   end 
  end 

  def sibling_responses 
    self.question.responses.where.not(id: self.id)
  end 

  def respondent_already_answered? 
    sibling_responses.exists?(respondent_id: self.respondent_id)
  end 


end 