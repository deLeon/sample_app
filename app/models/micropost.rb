class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  MAX_CHARS = 140
  validates :content, :presence => true, :length => { :maximum => MAX_CHARS }
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'

end

