class Website < ActiveRecord::Base
  attr_accessible :aws_key, :aws_secret, :input_bucket, :name, :output_bucket, :preview_bucket
  has_many :users
end
