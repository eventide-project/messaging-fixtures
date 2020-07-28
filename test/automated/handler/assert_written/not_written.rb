require_relative '../../automated_init'

context "Handler" do
  context "Assert Written" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::Output

    context "Message is Not Written" do
      some_class = Class.new do
        include Messaging::Message
      end

      fixture = Handler.build(handler, message)

      fixture.()

      fixture.assert_written(some_class)

      passed = fixture.test_session.test_passed?('Written')

      test "Not Passed" do
        refute(passed)
      end
    end
  end
end
