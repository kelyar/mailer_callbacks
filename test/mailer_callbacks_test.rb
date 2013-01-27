require 'test_helper'

class MailerCallbacksTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @recipient = 'test@localhost'

    Notifier.class_eval do
      def stop(m); end
      def start(m); end
    end
  end

  test "before: deny" do
    Notifier.class_eval do
      def start(message); false end
    end

    assert_emails(0) do
      Notifier.run.deliver
    end
  end

  test "before: allow" do
    Notifier.class_eval do
      def start(message)
        true
      end
    end

    assert_emails(1) do
      Notifier.run.deliver
    end
  end

  test "after delivery" do
    Notifier.class_eval do
      def stop(message) raise "111" end
    end
    assert_raise(RuntimeError) do
      Notifier.run.deliver
    end
  end
end

class Notifier < ActionMailer::Base

  def run
    to    = "test@example.com"
    from  = "tester@example.com"
    body  = render(inline: 'test', body: 'zhenya', layout: false)
    mail(:to => to, :body => body, :from => from)
  end

  def start(message)
  end

  def stop(message)
  end


  before_deliver :start, :except => [:index ]
  after_deliver :stop
end

