require_relative '../automated_init'

context "Written Message Fixture" do
  context "Assert Follows" do
    input_message = Controls::Message.example

    output_message_class = Controls::Event::Output

    attribute_names = [
      :example_id,
      { :quantity => :amount },
      :time,
    ]

    context "Follows" do
      output_message = output_message_class.follow(input_message, copy: attribute_names)

      fixture = WrittenMessage.build(output_message, input_message)

      fixture.assert_follows

      passed = fixture.test_session.test?('Follows: Input')

      test "Passed" do
        assert(passed)
      end
    end

    context "Doesn't Follow" do
      output_message = output_message_class.follow(input_message, copy: attribute_names)

      fixture = WrittenMessage.build(output_message, input_message)

      output_message.metadata.causation_message_stream_name = SecureRandom.hex

      fixture.assert_follows

      passed = fixture.test_session.test_passed?('Follows: Input, Output')

      test "Doesn't Pass" do
        refute(passed)
      end
    end
  end
end
