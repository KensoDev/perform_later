require 'spec_helper'


describe PerformLater::PayloadHelper do
  subject { PerformLater::PayloadHelper }

  describe :get_digest do
    it "should o something" do
      user = User.create

      digest = Digest::MD5.hexdigest({ :class => "DummyClass", 
        :method => :some_method, 
        :args => [1, 2, 3, "AR:User:#{user.id}"]
        }.to_s)

      args = PerformLater::ArgsParser.args_to_resque(1, 2, 3, user)
      subject.get_digest("DummyClass", :some_method, args).should == digest
    end
  end


end