module MailerCallbacks
  def self.included(base)
    base.class_eval do
      include ActiveSupport::Callbacks
      define_callbacks :deliver, :terminator => "result == false"
      set_callback :deliver, :before, :before_deliver, :if => respond_to?(:before_deliver)
      set_callback :deliver, :after,  :after_deliver,  :if => respond_to?(:after_deliver)
    end
  end
end

module Mail
  module MessageDeliveryOverride

    def deliver
      run_callbacks(:deliver) do
        super
      end
    end

    def deliver!
      run_callbacks(:deliver) do
        super
      end
    end
  end

  class Message
#    include ActiveSupport::Callbacks
    include MessageDeliveryOverride
  end
end
