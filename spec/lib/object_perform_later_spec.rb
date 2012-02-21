require 'spec_helper'

describe ObjectPerformLater do
  let(:enabled) do
    { 'enabled' => true } 
  end
  let(:disabled) do
    { 'enabled' => false }
  end

  it "should insert a task into resque when the config is enabled" do
    Resque.redis = $redis

    ResquePerformLater.stub!(:config).and_return(enabled)
    User.perform_later(:generic, :get_metadata)

    Resque.peek(:generic, 0, 20).length.should == 1
  end

  it "should send the method on the class when the config is disabled" do
    ResquePerformLater.stub!(:config).and_return(disabled)
    
    User.should_receive(:get_metadata)
    User.perform_later(:generic, :get_metadata)
  end
end