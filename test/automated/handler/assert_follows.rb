require_relative '../automated_init'

context "Handler" do
  context "Assert Follows" do
    message = Controls::Message.example
    output_message_class = Controls::Event::Output

    context "Follows" do
      handler = Controls::Handler.example

      fixture = Handler.build(handler, message)

      fixture.()

      output_message = fixture.assert_written(output_message_class)

      fixture.assert_follows(output_message)

      passed = fixture.test_session.test?('Follows: Input, Output')

      test "Passed" do
        assert(passed)
      end
    end

    context "Doesn't Follow" do
      handler = Controls::Handler.example

      fixture = Handler.build(handler, message)

      fixture.()

      output_message = fixture.assert_written(output_message_class)

      output_message.metadata.causation_message_stream_name = SecureRandom.hex

      fixture.assert_follows(output_message)

      passed = fixture.test_session.test_passed?('Follows: Input, Output')

      test "Doesn't Pass" do
        refute(passed)
      end
    end
  end
end
