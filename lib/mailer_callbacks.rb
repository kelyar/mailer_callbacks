module MailerCallbacks

  def self.included(base)
    base.class_eval do
      include ActiveSupport::Callbacks
      alias_method :deliverorig!, :deliver!
      define_callbacks :before_deliver, :after_deliver

      def deliver!(mail=@mail)
        result = run_callbacks(:before_deliver){|res,obj| res==false}
        if result
          res = deliverorig!(mail)
          run_callbacks(:after_deliver)
        end
      end
    end
  end
end
