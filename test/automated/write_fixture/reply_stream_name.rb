require_relative '../automated_init'

context "Write Fixture" do
  context "Assert Reply Stream Name" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"
      reply_stream_name = 'someReplyStream'

      writer.(message, stream_name, reply_stream_name: reply_stream_name)

      fixture = Write.build(writer, message.class)

      fixture.assert_reply_stream_name(reply_stream_name)

      passed = fixture.test_session.test_passed?('Reply stream name')

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"
      reply_stream_name = 'someReplyStream'

      writer.(message, stream_name, reply_stream_name: SecureRandom.hex)

      fixture = Write.build(writer, message.class)

      fixture.assert_reply_stream_name(reply_stream_name)

      passed = fixture.test_session.test_passed?('Reply stream name')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end
