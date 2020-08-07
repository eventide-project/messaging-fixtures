require_relative '../automated_init'

context "Message Fixture" do
  context "Assert Attributes Assigned" do
    message = Controls::Event.example
    message_class = message.class

    attribute_names = message_class.attribute_names

    fixture = Message.build(message)

    fixture.assert_attributes_assigned(attribute_names)

    context_text = 'Attributes Assigned'

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
