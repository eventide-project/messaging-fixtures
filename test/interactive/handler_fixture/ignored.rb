require_relative '../interactive_init'

context "Handler Fixture" do
  context "Ignored" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    message_sequence = message.metadata.global_position

    entity = Controls::Entity::Identified.example
    entity.sequence = message_sequence

    output_stream_name = "example-#{entity.id}"

    fixture(
      Handler,
      handler,
      message,
      entity
    ) do |handler|

      handler.assert_input_message do |f|
        f.assert_attributes_assigned
        f.assert_metadata_attributes_assigned
      end

      handler.refute_write
    end
  end
end
