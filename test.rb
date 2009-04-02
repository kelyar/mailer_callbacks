#!/usr/bin/env ruby

require 'rubygems'
require 'actionmailer' unless defined? ActionMailer::Base
require 'action_mailer/test_case'
require 'test/unit/ui/console/testrunner'

require 'mailer_filters'

class Notifier < ActionMailer::Base

  before_deliver :start
  after_deliver :stop

  def test(usr)
    recipients "test@example.com"
    from       "tester@example.com"
    body render(:inline => 'test',:body=>'zhenya',:layout =>false)
  end

  def start
  end

  def stop
  end
end


class NotifierMailerTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @recipient = 'test@localhost'
  end

  def test_before_forbid
    Notifier.class_eval do
      def start() false; end
    end

    assert_emails(0) do
      mail = Notifier.deliver_test(true)
    end
  end

  def test_before_grant
    Notifier.class_eval do
      def start() true; end
    end

    assert_emails(1) do
      mail = Notifier.deliver_test(true)
    end
  end
end

Test::Unit::UI::Console::TestRunner.run(NotifierMailerTest)
