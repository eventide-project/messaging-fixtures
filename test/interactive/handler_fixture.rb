require_relative 'interactive_init'

context "Handler Fixture" do
  handler = Controls::Handler.example
  message = Controls::Message.example
  entity = Controls::Entity::Identified.example

  entity_version = 11

  output_message_class = Controls::Event::Output
  output_stream_name = "example-#{entity.id}"

  fixture(
    Handler,
    handler,
    message,
    entity,
    entity_version
  ) do |handler|

  ## This written_message return should be a fixture that has
  ## the output message AND the input message
  ## All the subsequent asserts can be called against it
    written_message = handler.assert_written(output_message_class) do |f|
      f.assert_stream_name(output_stream_name)
      f.assert_expected_version(entity_version)
    end

    handler.assert_attributes_copied(written_message, [
      :example_id,
      { :quantity => :amount },
      :time,
    ])

    handler.assert_attributes_assigned(written_message)

    handler.assert_follows(written_message)
  end
end
