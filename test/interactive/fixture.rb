require_relative 'interactive_init'

context "Fixture" do
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
  ) do |fixture|

    fixture.assert_written(output_message_class)

    # fixture.assert_written(output_message_class) do |output|
    #   output.assert_attributes_copied
    #   output.assert_stream_name
    #   output.assert_follows
    #   output.assert_expected_version
    # end

    # fixture.refute_written(alternate_output_message_class)

  end
end
