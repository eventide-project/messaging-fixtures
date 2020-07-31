require_relative '../../../automated_init'

context "Handler Fixture" do
  context "Assert Write" do
    context "Block" do
      context "Block Parameter" do
        handler = Controls::Handler.example
        message = Controls::Message.example

        output_message_class = Controls::Event::Output

        fixture = Handler.build(handler, message)

        fixture.()

        parameter = nil
        fixture.assert_write(output_message_class) do |f|
          parameter = f
        end

        test "WrittenMessage fixture" do
          assert(parameter.is_a?(Write))
        end
      end
    end
  end
end
