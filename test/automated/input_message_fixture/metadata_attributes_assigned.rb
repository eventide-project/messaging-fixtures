require_relative '../automated_init'

context "Input Message Fixture" do
  context "Assert Metadata Attributes Assigned" do
    input_message = Controls::Message.example

    fixture = InputMessage.build(input_message)

    attribute_names = [:stream_name, :position, :global_position]

    fixture.assert_metadata_attributes_assigned(attribute_names)

    context_text = 'Metadata Attributes Assigned'

    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end

    attribute_context = fixture.test_session[context_text]

    context "stream_name" do
      passed = attribute_context.test_passed?('stream_name')

      test "Passed" do
        assert(passed)
      end
    end

    context "position" do
      passed = attribute_context.test_passed?('position')

      test "Passed" do
        assert(passed)
      end
    end

    context "global_position" do
      passed = attribute_context.test_passed?('global_position')

      test "Passed" do
        assert(passed)
      end
    end
  end
end
