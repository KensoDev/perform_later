require 'spec_helper'

describe PerformLater::Job do
  
  let(:job)    {PerformLater::Job.new("some_queue", "WorkerClass", "Klass_name", 2, :the_method)}
  let(:delay)  {42}

  before :each do
    
  end

  describe :enqueue do
    context "when called with :delay option" do
      it "should enqueue job in Resque with the given delay" do
        Resque.should_receive(:enqueue_in_with_queue)
        job.enqueue delay: delay
      end

      it "should create a regular resque job if delay option isn't given" do
        Resque::Job.should_receive(:create)
        job.enqueue
      end
    end
  end
end

