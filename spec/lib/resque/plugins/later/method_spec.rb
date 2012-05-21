require 'spec_helper'

describe Resque::Plugins::Later::Method do
  it "should include the sync method on the user model" do
    User.new.should respond_to(:long_running_method)
    User.new.should respond_to(:now_long_running_method)
  end


end