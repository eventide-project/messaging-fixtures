require_relative '../../../automated_init'

context "Handler Fixture" do
  context "Assert Write" do
    context "Block" do
      context "Message Is Not Written" do
        handler = Controls::Handler.example
        message = Controls::Message.example

        output_message_class = Class.new do
          include Messaging::Message
        end

        fixture = Handler.build(handler, message)

        fixture.()

        effect = nil
        fixture.assert_write(output_message_class) do
          effect = :_
        end

        test "Block is not executed" do
          assert(effect.nil?)
        end
      end
    end
  end
end
