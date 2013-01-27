module MailerCallbacks
  def self.included(base)
    base.class_eval do
      cattr_accessor :before_filters, :before_options, :after_filters

      def self.before_deliver(*args)
        self.before_options = args.last.is_a?(Hash) ? args.pop : {}
        self.before_filters = args

        register_interceptor(self)
      end

      # before
      def self.delivering_email(message)
        result, skip_before = true, false

        if !skip_before
          self.before_filters.each do |filter|
            if __send__(filter.to_sym, message).is_a? ActionMailer::Base::NullMail
              message.perform_deliveries = false
              break
            end
          end
        end
      end

      # after
      def self.delivered_email(message)
        self.after_filters.each do |filter|
          self.__send__(filter.to_sym, message)
        end
      end

      def self.after_deliver(*args)
        self.after_filters = args
        register_observer(self)
      end
    end
  end
end
