require_relative '../automated_init'

context "Written Message" do
  context "Stream Name" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = WrittenMessage.build(writer, message.class)

      fixture.()

      passed = fixture.test_session.test_passed?('Written')

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      fixture = WrittenMessage.build(writer, message.class)

      fixture.()

      passed = fixture.test_session.test_passed?('Written')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end
