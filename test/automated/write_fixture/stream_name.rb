require_relative '../automated_init'

context "Write Fixture" do
  context "Assert Stream Name" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = Write.build(writer, message.class)

      fixture.assert_stream_name(stream_name)

      passed = fixture.test_session.test_passed?('Stream name')

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, SecureRandom.hex)

      fixture = Write.build(writer, message.class)

      fixture.assert_stream_name(stream_name)

      passed = fixture.test_session.test_passed?('Stream name')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end
