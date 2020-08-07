require_relative '../../automated_init'

context "Message Fixture" do
  context "No Message" do
    context "Block Given" do
      message = nil

      fixture = Message.build(message) {}

      fixture.()

      context "Skipped Tests Detail Notice" do
        printed = fixture.test_session.detail?('Remaining message tests are skipped')

        test "Printed" do
          assert(printed)
        end
      end
    end
  end
end
