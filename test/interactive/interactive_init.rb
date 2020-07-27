ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= 'info'
ENV['LOG_TAGS'] ||= 'handle,message'

ENV['TEST_BENCH_DETAIL'] ||= 'on'

require_relative '../test_init'
