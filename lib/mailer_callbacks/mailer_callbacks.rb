module MailerCallbacks
  def self.included(base)
    base.class_eval do
      include ActiveSupport::Callbacks
      define_callbacks :before_deliver, :after_deliver
    end
  end
end

module Mail
  module MessageDeliveryOverride
    def around_deliver
      result = ::MailerCallbacks.run_callbacks(:before_deliver) { |res, _| res == false }
      if result
        super
        ::MailerCallbacks.run_callbacks(:after_deliver)
      end
    end

    def deliver
      around_deliver
    end

    def deliver!
      around_deliver
    end
  end

  class Message
    include MessageDeliveryOverride
  end
end
