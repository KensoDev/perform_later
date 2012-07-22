module PerformLater
  class PayloadHelper
    # Public: Get Digest for the loner key.
    #
    # klass - Class name.
    # method - Method name.
    # Args - Args to send on the method
    #
    # Examples => 
    #   PayloadHelper.get_digest("SomeClass", "some_method", "arg1", "arg2")
    # 
    def self.get_digest(klass, method, *args)
      args    = args.flatten
      payload = { :class => klass, :method => method.to_s, :args => args }.to_s
      digest  = Digest::MD5.hexdigest("#{payload}")

      "loner:#{digest}"
    end
  end
end