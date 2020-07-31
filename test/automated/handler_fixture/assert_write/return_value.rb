require_relative '../../automated_init'

context "Handler Fixture" do
  context "Assert Write" do
    context "Return Value" do
      handler = Controls::Handler.example
      message = Controls::Message.example

      output_message_class = Controls::Event::Output

      fixture = Handler.build(handler, message)

      fixture.()

      result = fixture.assert_write(output_message_class)

      context "Result" do
        test "Is a WrittenMessage fixture" do
          assert(result.is_a?(WrittenMessage))
        end

        context "Output Message" do
          output_message = result.output_message

          test "Handler fixture's written message" do
            assert(output_message.is_a?(output_message_class))
          end
        end

        context "Input Message" do
          input_message = result.input_message

          test "Handler fixture's input message" do
            assert(input_message == message)
          end
        end
      end
    end
  end
end
