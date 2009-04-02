require 'test_helper'

class MailerCallbacksTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @recipient = 'test@localhost'
  end

  test "before forbid" do
    Notifier.class_eval do
      def start() false; end
    end

    assert_emails(0) do
      Notifier.deliver_run
    end
  end

  test "before_grant" do
    Notifier.class_eval do
      def start() true; end
    end

    assert_emails(1) do
      Notifier.deliver_run
    end
  end
end

class Notifier < ActionMailer::Base

  before_deliver :start
  after_deliver :stop

  def run
    recipients "test@example.com"
    from       "tester@example.com"
    body render(:inline => 'test',:body=>'zhenya',:layout =>false)
  end

  def start
  end

  def stop
  end
end

