require_relative '../automated_init'

context "Message Fixture" do
  context "Message Given" do
    message = Controls::Event.example

    fixture = Message.build(message)

    fixture.()

    context_text = "Message: #{message.class.message_type}"
    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end
  end
end
