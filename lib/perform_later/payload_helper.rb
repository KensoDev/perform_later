module PerformLater
  class PayloadHelper
    def self.get_digest(klass, method, *args)
      args = args.flatten
      
      digest = Digest::MD5.hexdigest({:class => klass, :method => method, :args => args}.to_s)
      puts [{ :class => klass, :method => method, :args => args }.to_s]

      puts "Digest is: #{digest}"
      digest
    end
  end
end