require 'perform_later/plugins'

class BadDummyFinder 

end

class GoodDummyFinder 
  def self.find(runner_class, id)
    runner_class.find(id)
  end
end

describe PerformLater::Plugins do
  subject { PerformLater::Plugins }

  describe :finder_class do
    it "should be nil" do
      subject.finder_class.should == nil
    end
  end
  
  describe :add_finder do
    it "should not add the finder since it doens't have the proper method" do
      subject.add_finder(BadDummyFinder)
      subject.finder_class.should == nil
    end

    it "should add the finder since it has the proper method" do
      subject.add_finder(GoodDummyFinder)
      subject.finder_class.should == GoodDummyFinder
    end
  end    
end