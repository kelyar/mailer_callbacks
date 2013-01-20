# encoding: utf-8

require 'mailer_callbacks/mailer_callbacks'
require 'mailer_callbacks/version'

ActionMailer::Base.class_eval do
  include MailerCallbacks
end
