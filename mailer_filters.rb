module MailerCallbacks

  def self.included(base)
    base.class_eval do
      alias_method :deliverorig!, :deliver!

      def deliver!(mail=@mail)
        if before_deliver_callback(mail)
          deliverorig!(mail)
          after_deliver_callback(mail)
        end
      end

      def before_deliver_callback(mail) 
        logger.info "running before callback..."
        if before_filters
          before_filters.each do |action|
            return false if !send(action, mail)
          end
        end
        true
      end

      def after_deliver_callback(mail) 
        logger.info "running after callback..."
        if after_filters
          after_filters.each do |action|
            send(action, mail)
          end
        end
      end
    end
  end
end

module MailerFilters

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def before_deliver(*actions)
      self.before_filters = actions
    end

    def after_deliver(*actions)
      self.after_filters = actions
    end
  end
end

ActionMailer::Base.class_eval do
  cattr_accessor :before_filters, :after_filters
  include MailerCallbacks
  include MailerFilters
end
