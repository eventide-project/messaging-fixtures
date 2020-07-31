require_relative '../automated_init'

context "Handler" do
  context "Assert Attributes Assigned" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::Output

    fixture = Handler.build(handler, message)

    attribute_names = output_message_class.attribute_names

    fixture.()

    output_message = fixture.assert_written(output_message_class)

    fixture.assert_attributes_assigned(output_message, attribute_names)

    context_text = 'Attributes Assigned: Output'

    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end

    attribute_context = fixture.test_session[context_text]

    context "example_id" do
      passed = attribute_context.test_passed?('example_id')

      test "Passed" do
        assert(passed)
      end
    end

    context "amount" do
      passed = attribute_context.test_passed?('amount')

      test "Passed" do
        assert(passed)
      end
    end

    context "time" do
      passed = attribute_context.test_passed?('time')

      test "Passed" do
        assert(passed)
      end
    end

    context "processed_time" do
      passed = attribute_context.test_passed?('processed_time')

      test "Passed" do
        assert(passed)
      end
    end

    context "sequence" do
      passed = attribute_context.test_passed?('sequence')

      test "Passed" do
        assert(passed)
      end
    end
  end
end
