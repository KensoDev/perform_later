require 'spec_helper'


describe PerformLater::PayloadHelper do
  subject { PerformLater::PayloadHelper }

  describe :get_digest do
    it "should o something" do
      user = User.create

      digest = Digest::MD5.hexdigest({ :class => "DummyClass", 
        :method => :some_method.to_s, 
        :args => ["AR:User:#{user.id}"]
        }.to_s)

      args = PerformLater::ArgsParser.args_to_resque(user)
      subject.get_digest("DummyClass", :some_method, args).should == digest
    end
  end
end