require 'spec_helper'

describe Resque::Plugins::Later::Method do
  before(:each) { Resque.redis = $redis }
  let(:user) { User.create }

  it "shold define the correct method on the user model" do
    user.should respond_to(:long_running_method)
    user.should respond_to(:now_long_running_method)
  end

  it "should insert a task into resque when the config is enabled" do
    PerformLater.should_receive(:enabled?).and_return(true)    
    Resque::Job.should_receive(:create)
    
    user.now_long_running_method
  end

  it "should send the method on the class when the config is disabled" do
    PerformLater.stub!(:enabled?).and_return(false)
    user.long_running_method
    Resque.peek(:generic, 0, 20).length.should == 0
  end


end