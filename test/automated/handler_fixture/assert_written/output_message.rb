require_relative '../../automated_init'

context "Handler Fixture" do
  context "Assert Written" do
    context "Output Message" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      output_message_class = Controls::Event::Output

      context "Output Message" do
        fixture = Handler.build(handler, message)

        fixture.()

        output_message = fixture.assert_written(output_message_class)

        test "Returned" do
          assert(output_message.is_a?(output_message_class))
        end
      end
    end
  end
end
