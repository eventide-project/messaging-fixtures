require_relative '../../../automated_init'

context "Handler" do
  context "Assert Written" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::Output

    context "Block" do
      context "Message Is Written" do
        fixture = Handler.build(handler, message)

        fixture.()

        effect = nil
        fixture.assert_written(output_message_class) do
          effect = :_
        end

        test "Block is executed" do
          refute(effect.nil?)
        end
      end
    end
  end
end
