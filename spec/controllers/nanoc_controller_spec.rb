require 'spec_helper'

describe NanocController do
  it "should create delayed job" do
    user = create :user
    sign_in user
    site = create :website, :user => user
    expect do
      get :compile, :id => site.id
    end.to change(Delayed::Job, :count).by(1)

    job = Delayed::Job.last
    site.reload.delayed_job_id.should == job.id
  end

end
