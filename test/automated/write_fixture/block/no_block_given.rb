require_relative '../../automated_init'

context "Write Fixture" do
  context "Block" do
    context "No Block Given" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      writer.(message, stream_name)

      fixture = Write.build(writer, message.class)

      test "Is an error" do
        assert_raises(Write::Error) do
          fixture.()
        end
      end
    end
  end
end
