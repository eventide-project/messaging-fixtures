require_relative '../automated_init'

context "Handler" do
  context "Assert Attributes Copied" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::Output

    fixture = Handler.build(handler, message)

    copied_attribute_names = [
      :example_id,
      { :quantity => :amount },
      :time,
    ]

    fixture.()

    output_message = fixture.assert_written(output_message_class)

    fixture.assert_attributes_copied(output_message, copied_attribute_names)

    context_text = 'Attributes Copied: Input => Output'

    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end

    attribute_context = fixture.test_session[context_text]

    context "example_id" do
      passed = attribute_context.test?('example_id')

      test "Passed" do
        assert(passed)
      end
    end

    context "quantity => amount" do
      passed = attribute_context.test?('quantity => amount')

      test "Passed" do
        assert(passed)
      end
    end

    context "time" do
      passed = attribute_context.test?('time')

      test "Passed" do
        assert(passed)
      end
    end
  end
end
