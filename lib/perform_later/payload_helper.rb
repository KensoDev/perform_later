module PerformLater
  class PayloadHelper
    def self.get_digest(klass, method, *args)
      puts [klass, method, args]
      digest = Digest::MD5.hexdigest({:class => klass, :method => method, :args => args.flatten}.to_s)
      
      puts "Digest is: #{digest}"

      digest
    end
  end
end