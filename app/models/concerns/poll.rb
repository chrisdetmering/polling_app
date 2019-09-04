
#     t.string "title", null: false
#     t.integer "author_id", null: false
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["author_id"], name: "index_polls_on_author_id"



class Poll < ApplicationRecord
  validates :title, presence: true
  
  belongs_to :author, 
    primary_key: :id, 
    foreign_key: :author_id,
    class_name: :User

  has_many :questions, 
    primary_key: :id, 
    foreign_key: :poll_id,
    class_name: :Poll
end