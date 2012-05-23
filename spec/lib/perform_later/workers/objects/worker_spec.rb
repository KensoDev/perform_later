require 'spec_helper'

class DummyClass 
  def self.do_somthing_with_array_of_hashes(arr)
    arr[0][:foo]
  end

  def self.do_something_without_args
    true
  end

end

describe PerformLater::Workers::Objects::Worker do
  subject { PerformLater::Workers::Objects::Worker }

  it "should pass an array of hashes into the method" do
    arr = [
      { foo: "bar" },
      { bar: "foo" }
    ]

    arr = PerformLater::ArgsParser.args_to_resque(arr)
    subject.perform("DummyClass", :do_somthing_with_array_of_hashes, arr).should == "bar"
  end

  it "should pass no args to the method" do
    subject.perform("DummyClass", :do_something_without_args).should == true
  end
end