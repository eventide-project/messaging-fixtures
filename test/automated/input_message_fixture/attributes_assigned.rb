require_relative '../automated_init'

context "Input Message Fixture" do
  context "Assert Attributes Assigned" do
    input_message = Controls::Message.example

    fixture = InputMessage.build(input_message)

    attribute_names = input_message.class.attribute_names

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

    context "quantity" do
      passed = attribute_context.test_passed?('quantity')

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
  end
end
