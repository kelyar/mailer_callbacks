require 'test_helper'

class MailerCallbacksTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @recipient = 'test@localhost'
  end

  test "before: forbid" do
    Notifier.class_eval do
      def start() false; end
    end

    assert_emails(0) do
      Notifier.run
    end
  end

  test "before: grant" do
    Notifier.class_eval do
      def start() true; end
    end

    assert_emails(1) do
      Notifier.run
    end
  end
end

class Notifier < ActionMailer::Base

  def before_deliver; start end
  def after_deliver; stop end

  def run
    to    = "test@example.com"
    from  = "tester@example.com"
    body  = render(inline: 'test', body: 'zhenya', layout: false)
    mail(:to => to, :body => body, :from => from)
  end

  def start
  end

  def stop
  end
end

