require 'spec_helper'

class DummyClass 
  def self.do_something_really_heavy
    
  end
end

describe ObjectPerformLater do
  it "should insert a task into resque when the config is enabled" do
    Resque.redis = $redis

    PerformLater.config.stub!(:enabled?).and_return(true)
    User.perform_later(:generic, :get_metadata)

    Resque.peek(:generic, 0, 20).length.should == 1
  end

  it "should send the method on the class when the config is disabled" do
    PerformLater.config.stub!(:enabled?).and_return(false)
    
    User.should_receive(:get_metadata)
    User.perform_later(:generic, :get_metadata)

    Resque.peek(:generic, 0, 20).length.should == 0
  end

  it "should only add the method a single time to the queue" do
    PerformLater.config.stub!(:enabled?).and_return(true)
    
    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)

    Resque.peek(:generic, 0, 20).length.should == 1
  end


end