require 'rubygems'
require 'test/unit'
require 'turn/autorun'
require 'active_support'
require 'active_support/test_case'
require 'action_mailer'

require 'mailer_callbacks'

Turn.config do |c|
 # use one of output formats:
 # :outline  - turn's original case/test outline mode [default]
 # :progress - indicates progress with progress bar
 # :dotted   - test/unit's traditional dot-progress mode
 # :pretty   - new pretty reporter
 # :marshal  - dump output as YAML (normal run mode only)
 # :cue      - interactive testing
 c.format  = :outline
 # turn on invoke/execute tracing, enable full backtrace
 c.trace   = 100
 # use humanized test names (works only with :outline format)
 c.natural = true
end
