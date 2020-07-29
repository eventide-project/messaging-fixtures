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
  ) do |fixture|

    ## returns output message object so that it can be used in
    ## testing attribute values against input
    fixture.assert_written(output_message_class) do |written_message|
      written_message.assert_stream_name(output_stream_name)
    end

    ## return output message back to handler fixture
    ## to execute atribute assertions against
    # fixture.assert_written(output_message_class) do |output|
    ## If found, call rest of assertions
    #   output.assert_stream_name
    #   output.assert_expected_version
    # end

    # fixture.assert_follows  <-- input message

    # fixture.assert_attributes_copied(attributes)

    # fixture.refute_written(alternate_output_message_class)

  end
end
