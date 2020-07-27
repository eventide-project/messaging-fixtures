require_relative '../../automated_init'

context "Setup Handler" do
  context "Time" do
    context "Specified" do
      input_message = Controls::Message.example

      time = Time.now

      handler = Controls::Handler.example

      fixture = Handler.build(
        handler,
        input_message,
        time: time
      )

      clock = handler.clock

      test "Handler clock time is set to fixture's time" do
        assert(clock.now == time)
      end
    end
  end
end
