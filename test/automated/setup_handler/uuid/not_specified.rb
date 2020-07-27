require_relative '../../automated_init'

context "Setup Handler" do
  context "Identifier" do
    context "Not Specified" do
      input_message = Controls::Message.example

      handler = Controls::Handler.example

      fixture = Handler.build(
        handler,
        input_message
      )

      identifier = handler.identifier

      default_id = Handler::Defaults.uuid

      test "Handler identifier is set to default ID" do
        assert(identifier.get == default_id)
      end
    end
  end
end
