require_relative '../automated_init'

context "Write Fixture" do
  context "Written" do
    writer = Messaging::Write::Substitute.build
    message = Controls::Event.example
    stream_name = "example-#{message.example_id}"

    writer.(message, stream_name)

    fixture = Write.build(writer, message.class) {}

    fixture.()

    passed = fixture.test_session.test_passed?('Written')

    test "Passed" do
      assert(passed)
    end
  end
end
