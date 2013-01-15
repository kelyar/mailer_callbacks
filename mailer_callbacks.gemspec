Gem::Specification.new do |s|
  s.name            = "MailerCallbacks"
  s.version         = "2.0.0a"
  s.platform        = Gem::Platform::RUBY
  s.summary         = "Mailer callbacks"

  s.description = <<-EOF
Small set of callbacks that can be useful if you do pre-post mail processing
EOF

  s.files           = Dir['{lib/**/*,test/**/*}'] +
                        %w(mailer_callbacks.gemspec Rakefile README)
  s.require_path    = 'lib'
  s.test_files      = Dir['test/*_test.rb']

  s.author          = 'Evgeniy Kelyarsky'
  s.email           = 'kelyar@gmail.com'
  s.homepage        = 'http://github.com/kelyar/mailer_callbacks'

  s.add_development_dependency 'rake'
end
