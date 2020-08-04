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

      written_message = nil

      handler.assert_written_message(written_message) do |f|
        comment "Block is not executed when there's no written message"
      end
    end
  end
end
