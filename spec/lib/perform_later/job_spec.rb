require 'spec_helper'

describe PerformLater::Job do
  
  let(:job)    {PerformLater::Job.new("some_queue", "WorkerClass", "Klass_name", 2, :the_method)}
  let(:delay)  {42}

  describe :enqueue do
    context "with :delay option" do
      it "should enqueue job in Resque with the given delay" do
        Resque.should_receive(:enqueue_in_with_queue)
        job.enqueue delay: delay
      end
    end
    context "without :delay option" do
      it "should create a regular resque job if delay option isn't given" do
        Resque::Job.should_receive(:create)
        job.enqueue
      end
    end
  end
end

