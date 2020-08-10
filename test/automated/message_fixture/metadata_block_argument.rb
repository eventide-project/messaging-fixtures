require_relative '../automated_init'

context "Message Fixture" do
  context "Metadata" do
    context "Block Argument" do
      message = Controls::Event.example

      fixture = Message.build(message)

      block_arg = nil
      fixture.assert_metadata do |f|
        block_arg = f
      end

      test "Is a Metadata fixture" do
        assert(block_arg.is_a?(Metadata))
      end
    end
  end
end
