require 'spec_helper'

describe Resque::Plugins::Later::Method do
  before(:each) { PerformLater.config.enabled = true }
  before(:each) { Resque.redis = $redis }

  context "enabled" do
    before(:each) do
      PerformLater.config.stub(:enabled?).and_return(true)
      User.later :long_running_method
    end

    it "should insert a task into resque when the config is enabled" do
      user = User.create
      user.long_running_method
      Resque.peek(:generic, 0, 20).length.should == 1
    end
  end

  context "loner" do
    before(:each) do
      PerformLater.config.stub(:enabled?).and_return(true)
      User.later :lonely_long_running_method, loner: true
    end

    it "should only add a single method to the queue, since the config is with a loner" do
      user = User.create
      user.lonely_long_running_method
      user.lonely_long_running_method
      user.lonely_long_running_method
      user.lonely_long_running_method
      user.lonely_long_running_method
      Resque.peek(:generic, 0, 20).length.should == 1
    end

    it "should only add a single method to the queue, since the config is with a loner when using perform_later! method" do
      user = User.create
      user.perform_later!(:generic, :lonely_long_running_method)
      user.perform_later!(:generic, :lonely_long_running_method)
      user.perform_later!(:generic, :lonely_long_running_method)
      user.perform_later!(:generic, :lonely_long_running_method)
      user.perform_later!(:generic, :lonely_long_running_method)
      Resque.peek(:generic, 0, 20).length.should == 1
    end
  end

  context "disabled" do
    it "should send the method on the class when the config is disabled" do
      user = User.create
      user.now_long_running_method
      Resque.peek(:generic, 0, 20).length.should == 0
    end
  end

  context 'arguments to Resque' do
    it 'should send no args to resque' do
      user = User.create
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::ActiveRecord::Worker, 'User', user.id, :lonely_long_running_method)
      user.perform_later(:generic, :lonely_long_running_method)
    end

    it 'should send 1 arg to resque' do
      user = User.create
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::ActiveRecord::LoneWorker, 'User', user.id, :lonely_long_running_method, 1)
      user.perform_later!(:generic, :lonely_long_running_method, 1)
    end
  end

  it "shold define the correct method on the user model" do
    user = User.create
    user.should respond_to(:long_running_method)
    user.should respond_to(:now_long_running_method)
  end

  describe :perform_later! do
    it "should send the correct params on the method (with hash)" do
      PerformLater.config.stub(:enabled?).and_return(false)
       user = User.create
       user.should_receive(:method_with_hash_as_option).with({:some_option => "Brown fox"})
       user.perform_later!(:generic, :method_with_hash_as_option, :some_option => "Brown fox")
    end

    it "should send the correct params on the method (with integer)" do
      PerformLater.config.stub(:enabled?).and_return(false)
       user = User.create
       user.should_receive(:method_with_integer_option).with(1).and_return(1)
       user.perform_later!(:generic, :method_with_integer_option, 1)
    end
  end

  context "delay" do

    let(:enqueue_in) {5}
    let(:actual_enqueue) {Time.now + enqueue_in}

    before(:each) do
      PerformLater.config.stub(:enabled?).and_return(true)
      User.later :delayed_long_running_method, :delay => enqueue_in
    end

    describe :delay do
      it "should delay enqueuing for the duration of time given, if delay time is given" do
        user = User.create
        user.delayed_long_running_method
        Resque.redis.llen("delayed:#{actual_enqueue.to_i}").should == 1
      end
    end

    describe :perform_later_in do
      it "should delay enqueuing for the duration of delay time given" do
        user = User.create
        user.perform_later_in(enqueue_in, :generic, :delayed_long_running_method)
        Resque.redis.llen("delayed:#{actual_enqueue.to_i}").should == 1
      end
    end
  end
end
