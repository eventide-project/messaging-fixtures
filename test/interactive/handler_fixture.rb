require_relative 'interactive_init'

context "Handler Fixture" do
  handler = Controls::Handler.example
  message = Controls::Message.example
  entity = Controls::Entity::Identified.example

  output_message_class = Controls::Event::Output
  output_stream_name = "example-#{entity.id}"

  fixture(
    Handler,
    handler,
    message,
    entity
  ) do |handler|

    written_message = handler.assert_written(output_message_class) do |written_message|
      written_message.assert_stream_name(output_stream_name)
    end

    # To Do
    # handler.assert_attributes_copied(written_message)
    # handler.assert_attributes_assigned(written_message)

  end
end
