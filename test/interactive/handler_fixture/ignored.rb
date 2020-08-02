require_relative '../interactive_init'

context "Handler Fixture" do
  context "Ignored" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    sequence = message.metadata.global_position

    entity = Controls::Entity::Identified.example
    entity.sequence = sequence

    output_message_class = Controls::Event::Output
    alternate_output_message_class = Controls::Event::AlternateOutput

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

      # handler.refute_write(output_message_class)
      # handler.refute_write(alternate_output_message_class)

      handler.refute_write
      handler.refute_write(stream_name: output_stream_name)
    end
  end
end
