require_relative '../interactive_init'

context "Handler Fixture" do
  context "Output" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::AlternateOutput

    fixture(
      Handler,
      handler,
      message,
    ) do |handler|

      # written_message = handler.assert_write(output_message_class)

written_message = nil
      handler.assert_written_message(written_message) do
        assert(true)
      end
    end
  end
end
