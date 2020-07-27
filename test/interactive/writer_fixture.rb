require_relative 'interactive_init'

context "Writer Fixture" do
  writer = Messaging::Write::Substitute.build
  message = Controls::Event.example
  stream_name = "example-#{message.example_id}"

  writer.(message, stream_name)

  message_class = message.class

  fixture = fixture(
    Writer,
    writer,

  )

  fixture.assert_written(message_class)

end
