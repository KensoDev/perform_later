require 'spec_helper'

class DummyClass
  def self.do_something_really_heavy

  end

  def self.do_something_with_string(value)
    value
  end

  def self.do_something_with_user(user)
    user
  end

  def self.do_something_with_multiple_args(a, b)
    "#{a}, #{b}"
  end

  def self.do_something_with_optional_hash(options = {})
    options.blank?
  end

  def self.do_something_with_array(arr)
    arr
  end
end

describe ObjectPerformLater do
  it "should insert a task into resque when the config is enabled" do
    Resque.redis = $redis

    PerformLater.config.stub(:enabled?).and_return(true)
    User.perform_later(:generic, :get_metadata)

    Resque.peek(:generic, 0, 20).length.should == 1
  end

  it "should send the method on the class when the config is disabled" do
    PerformLater.config.stub(:enabled?).and_return(false)

    User.should_receive(:get_metadata)
    User.perform_later(:generic, :get_metadata)

    Resque.peek(:generic, 0, 20).length.should == 0
  end

  it "should only add the method a single time to the queue" do
    PerformLater.config.stub(:enabled?).and_return(true)

    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)
    DummyClass.perform_later!(:generic, :do_something_really_heavy)

    Resque.peek(:generic, 0, 20).length.should == 1
  end

  describe "When Enabled" do
    let(:user) { User.create }

    it "should pass no values" do
      PerformLater.config.stub(:enabled?).and_return(true)
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::Objects::Worker, "DummyClass", :do_something_with_array)
      DummyClass.perform_later(:generic, :do_something_with_array)
    end

    it "should pass the correct value (array)" do
      PerformLater.config.stub(:enabled?).and_return(true)
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::Objects::Worker, "DummyClass", :do_something_with_array, [1,2,3,4,5])
      DummyClass.perform_later(:generic, :do_something_with_array, [1,2,3,4,5])
    end

    it "should pass multiple args" do
      PerformLater.config.stub(:enabled?).and_return(true)
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::Objects::Worker, "DummyClass", :do_something_with_multiple_args, 1, 2)
      DummyClass.perform_later(:generic, :do_something_with_multiple_args, 1, 2)
    end

    it "should pass AR and hash" do
      PerformLater.config.stub(:enabled?).and_return(true)
      Resque::Job.should_receive(:create).with(:generic, PerformLater::Workers::Objects::Worker, "DummyClass", :do_something_with_multiple_args, "AR:User:#{user.id}", "---\n:a: 2\n")
      DummyClass.perform_later(:generic, :do_something_with_multiple_args, user, {a: 2})
    end
  end

  describe :perform_later do
    before(:each) do
      PerformLater.config.stub(:enabled?).and_return(false)
    end

    it "should pass the correct value (String)" do
      DummyClass.perform_later(:generic, :do_something_with_string, "Avi Tzurel").should == "Avi Tzurel"
    end

    it "should pass the correct value (AR object)" do
      user = User.create
      DummyClass.perform_later(:generic, :do_something_with_user, user).should == user
    end

    it "should pass the correct value (optional hash)" do
      DummyClass.perform_later(:generic, :do_something_with_optional_hash).should == true
    end

    it "should pass multiple args" do
      DummyClass.perform_later(:generic, :do_something_with_multiple_args, 1, 2).should == "1, 2"
    end

    it "should pass AR and hash" do
      u = User.create
      DummyClass.perform_later(:generic, :do_something_with_multiple_args, u, {a: 2}).should == "#{u}, {:a=>2}"
    end
  end

  describe :perform_later! do
    before(:each) do
      PerformLater.config.stub(:enabled?).and_return(false)
    end
    it "should pass the correct value (String)" do
      DummyClass.perform_later!(:generic, :do_something_with_string, "Avi Tzurel").should == "Avi Tzurel"
    end

    it "should pass the correct value (AR object)" do
      user = User.create
      DummyClass.perform_later!(:generic, :do_something_with_user, user).should == user
    end

    it "should pass the correct value (optional hash)" do
      DummyClass.perform_later!(:generic, :do_something_with_optional_hash).should == true
    end

    it "should pass multiple args" do
      DummyClass.perform_later!(:generic, :do_something_with_multiple_args, 1, 2).should == "1, 2"
    end

    it "should pass AR and hash" do
      u = User.create
      DummyClass.perform_later!(:generic, :do_something_with_multiple_args, u, {a: 2}).should == "#{u}, {:a=>2}"
    end
  end
end