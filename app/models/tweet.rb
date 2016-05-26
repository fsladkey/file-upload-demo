# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  body       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  author_id  :integer          not null
#

class Tweet < ActiveRecord::Base
  validates :body, presence: true
  validates :author_id, presence: true


  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_one(
    :country,
    through: :author,
    source: :country
  )
end
