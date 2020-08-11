require_relative '../automated_init'

context "Write Fixture" do
  context "Assert Written" do
    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      fixture = Write.build(writer, message.class)

      fixture.()

      failed = fixture.test_session.test_failed?('Written')

      test "Failed" do
        assert(failed)
      end
    end
  end
end
