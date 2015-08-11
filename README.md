Mailer Callbacks
================


I had a task to save all emails we send to user - not content, of course, but at least email and subject (or template). It's pretty useful if you send lots of emails and want to know which ones this particular user received. 

Easy way was to put some SentMailLog.create() in the end of every method of ActionMailer::Base ancestors. Doesn't look really DRY, but it will work. I looked thru ActionMailer API but there were no hooks like AR or even ActionController has. That's why I wrote this tiny 1Kb extension to AM that adds `after_deliver` callback for my Notifier class.

Right after that I plugged in open_id_authentication which is great but many more issues came out. It appears that my users no longer have emails because they could register with openid and some providers just ignore `required => {:email}`. I had to add "unless User.current_user.openid?" to all of my deliver_* methods.  That's when `before_deliver` saved me. If any of your actions specified in before_deliver method returns false, no email will be sent. But no one cares what your after_deliver returns. It's pretty similar to ActiveRecord's before_save/after_save callbacks.

Many use cases can be found: you can mark your users as bounced if there are problems with their email accounts - no emails should be sent to them. Or you can have `unsubscribe all our news` flag like we have. This can also be verified in "before_deliver". If you need to access email data just use instance variables inside your callbacks, like @subject, @recipients, @body,etc.

ok, no more words, here is the CODE:

class Notifier < ActionMailer::Base
  before_deliver :openid_stub?
  after_deliver :save_email

  def openid_stub?
    @recipients.to_s.include?('openid_stub')
  end

  def save_email
    ...
    SentMailLog.create(:email=>@recipients.join(","), :subj => @subject)
  end
end

TODO:
- add usual [:except, :only] params
- yield if block_given?
--add some tests-- DONE

Copyright (c) 2008 Evgeniy Kelyarsky, released under the MIT license
