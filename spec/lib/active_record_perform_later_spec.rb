require 'spec_helper'
require 'resque'

describe ActiveRecordPerformLater do
  let(:user) { User.create }

  it "should insert a task into resque when the config is enabled" do
    Resque.redis = $redis

    PerformLater.stub!(:enabled?).and_return(true)
    user.perform_later(:generic, :full_name)

    Resque.peek(:generic, 0, 20).length.should == 1
  end

  it "should send the method on the class when the config is disabled" do
    PerformLater.stub!(:enabled?).and_return(false)
    user.should_receive(:full_name)
    user.perform_later(:generic, :full_name)
  end
end