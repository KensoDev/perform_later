require 'spec_helper'

describe PerformLater::ArgsParser do
  subject { PerformLater::ArgsParser }
  let(:user) { User.create }

  context "args to resque" do

    it "should convert array of hashes correctly" do
      arr = [
        { something: "aaa" },
        { something: "bbb" },
        { something: "ccc" },
        { something: "ddd" },
        { something: "eee" }
      ]
      subject.args_to_resque(arr).class.should == Array
    end

    it "should translate array of hashes back and forth again" do
      arr = [
        { something: "aaa" },
        { something: "bbb" },
        { something: "ccc" },
        { something: "ddd" },
        { something: "eee" }
      ]
      to_resque = subject.args_to_resque(arr).to_json
      a = JSON.parse(to_resque)
      from_resque = subject.args_from_resque(a)
      
      from_resque.should == arr
    end

    it "should convert the AR object to the proper string" do
      user_id = user.id

      subject.args_to_resque(user).should == "AR:User:#{user_id}"
    end

    it "should convert a hash into YAML string so that Resque will be able to JSON convert it" do
      hash = { name: "something", other: "something else" }
      subject.args_to_resque(hash)[0].class.name.should == "String"
    end

    it "should be able to load a yaml from the string and translate it into the same hash again" do
      hash = { name: "something", other: "something else" }
      yaml = subject.args_to_resque(hash)

      loaded_yaml = YAML.load(yaml)

      loaded_yaml[:name].should == "something"
      loaded_yaml[:other].should == "something else"
    end

    it "should convert a class to the proper string representation" do
      klass = User
      subject.args_to_resque(klass).should == "CLASS:User"
    end
  end

  context "args from resque" do
    it "should give me a hash back when I pass a yaml representation of it" do
      hash = { name: "something", other: "something else" }
      yaml = *hash.to_yaml

      args = subject.args_from_resque(yaml)
      args[0].class.name.should == "Hash"
      args[0][:name].should == "something"
      args[0][:other].should == "something else"
    end

    it "Should give me a user model back when I pass the proper string" do
      args_input = *"AR:User:#{user.id}"
      args = subject.args_from_resque(args_input)
      args[0].should == user
    end
  end
end