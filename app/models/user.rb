class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :registerable
  #:recoverable, :trackable, :registerable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :aws_key, :aws_secret

  has_many :websites
  
  def name
    email
  end

end
