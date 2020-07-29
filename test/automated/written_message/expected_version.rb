require_relative '../automated_init'

context "Written Message" do
  context "Expected Version" do
    context "Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name, expected_version: 11)

      fixture = WrittenMessage.build(writer, message.class)

      fixture.assert_expected_version(11)

      passed = fixture.test_session.test_passed?('Expected version')

      test "Passed" do
        assert(passed)
      end
    end

    context "Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name, expected_version: 111)

      fixture = WrittenMessage.build(writer, message.class)

      fixture.assert_expected_version(11)

      passed = fixture.test_session.test_passed?('Expected version')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end
