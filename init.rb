require 'mailer_callbacks'

ActionMailer::Base.class_eval do
  include MailerCallbacks
end
