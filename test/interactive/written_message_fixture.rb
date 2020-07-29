require_relative 'interactive_init'

context "Written Message Fixture" do
  writer = Messaging::Write::Substitute.build
  message = Controls::Event.example
  stream_name = "example-#{message.example_id}"
  expected_version = 1

  writer.(message, stream_name, expected_version: expected_version)

  message_class = message.class

  fixture = fixture(
    WrittenMessage,
    writer,
    message
  )

  fixture.assert_stream_name(stream_name)
  fixture.assert_expected_version(expected_version)
end
