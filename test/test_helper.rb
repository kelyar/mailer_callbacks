require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'

require 'actionmailer'

require 'mailer_callbacks'

class ActionMailer::Base
  include MailerCallbacks
end
  
