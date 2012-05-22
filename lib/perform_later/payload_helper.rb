module PerformLater
  class PayloadHelper
    def self.get_digest(klass, method, args)
      puts [klass, method, args]
      Digest::MD5.hexdigest({:class => klass, :method => method, :args => args}.to_s)
    end
  end
end