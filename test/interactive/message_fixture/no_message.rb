require_relative '../interactive_init'

context "Message Fixture" do
  context "No Message" do
    message = nil

    fixture(
      Message,
      message
    ) do |message|
    end
  end
end
