require_relative '../automated_init'

context "Message Fixture" do
  context "No Message" do
    message = nil

    fixture = Message.build(message) {}

    fixture.()

    context_text = 'Message'
    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end

    written_message_context = fixture.test_session[context_text]
    context "Not nil" do
      failed = written_message_context.test_failed?('Not nil')

      test "Failed" do
        assert(failed)
      end
    end
  end
end
