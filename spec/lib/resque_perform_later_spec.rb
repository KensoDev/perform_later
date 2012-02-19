require 'spec_helper'

describe ResquePerformLater do
  let(:user) { User.create }

  context "args to resque" do
    it "should convert the AR object to the proper string" do
      user_id = user.id

      ResquePerformLater.args_to_resque(user).length.should == 1
      ResquePerformLater.args_to_resque(user)[0].should == "AR:User:#{user_id}"
    end

    it "should convert a hash into YAML string so that Resque will be able to JSON convert it" do
      hash = {name: "something", other: "something else"}
      ResquePerformLater.args_to_resque(hash)[0].class.name.should == "String"
    end

    it "should be able to load a yaml from the string and translate it into the same hash again" do
      hash = {name: "something", other: "something else"}
      yaml = ResquePerformLater.args_to_resque(hash)[0]

      loaded_yaml = YAML.load(yaml)
      
      loaded_yaml[:name].should == "something"
      loaded_yaml[:other].should == "something else"
    end
  end

  context "args from resque" do
    
  end
end