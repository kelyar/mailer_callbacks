module MailerCallbacks
  def self.included(base)
    base.class_eval do
      include ActiveSupport::Callbacks

      define_callbacks :deliver, :terminator => "result == false"
      set_callback :deliver, :around, :delivery_around_wrapper

      cattr_accessor :before_filters, :before_options, :after_filters

      def delivery_around_wrapper
        message = self
        result, skip_before = true, false
        before_options = self.class.before_options

        skip_before = true if before_options.include?(:only)   && !before_options[:only].include?(message.action_name)
        skip_before = true if before_options.include?(:except) && before_options[:except].include?(message.action_name)

        if !skip_before
          self.class.before_filters.each do |filter|
            if __send__(filter.to_sym) == false
              result = false
              break
            end
          end
        end

        if skip_before || result == true
          yield(message)
          self.class.after_filters.each do |filter|
            __send__(filter.to_sym, message)
          end
        end
      end

      def self.before_deliver(*args)
        self.before_options = args.last.is_a?(Hash) ? args.pop : {}
        self.before_filters = args

        wrap_methods_in_callback(mailer_actions)
      end

      def self.after_deliver(*args)
        self.after_filters = args
      end

      private
      def self.mailer_actions(obj=self)
        obj.public_instance_methods(ancestors = false)
      end

      def self.wrap_methods_in_callback(possible_mails)
        overloaded_mail_actions = Module.new do
          possible_mails.each do |mail_action|
            define_method("#{mail_action}") do
              run_callbacks(:deliver) do
                super
              end
            end
          end
        end
        self.__send__ :include, overloaded_mail_actions
      end
    end
  end
end
