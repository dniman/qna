class EnterEmail
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
end
