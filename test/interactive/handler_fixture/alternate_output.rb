require_relative '../interactive_init'

context "Handler Fixture" do
  context "Alternate Output" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    entity = Controls::Entity::Identified.example
    entity.alternate_condition = true

    message_sequence = message.metadata.global_position
    entity.sequence = message_sequence - 1

    entity_version = 11

    output_message_class = Controls::Event::AlternateOutput
    output_stream_name = "example-#{entity.id}"

    alternate_output_message_class = Controls::Event::Output

    fixture(
      Handler,
      handler,
      message,
      entity,
      entity_version
    ) do |handler|

      handler.assert_input_message

      written_message = handler.assert_write(output_message_class) do |f|
        f.assert_stream_name(output_stream_name)
        f.assert_expected_version(entity_version)
      end

      written_message.() do |f|

        f.assert_follows

        f.assert_attributes_copied([
          :example_id,
          { :quantity => :amount },
          :time,
        ])

        f.assert_attributes_assigned
      end

      handler.refute_write(alternate_output_message_class)
    end
  end
end
