require_relative '../../automated_init'

context "Setup Handler" do
  context "Time" do
    context "Not Specified" do
      input_message = Controls::Message.example

      handler = Controls::Handler.example

      fixture = Handler.build(
        handler,
        input_message
      )

      clock = handler.clock

      default_time = Handler::Defaults.time

      test "Handler clock time is set to default time" do
        assert(clock.now == default_time)
      end
    end
  end
end
