require_relative 'interactive_init'

context "Write Fixture" do
  input_message = Controls::Message.example

  fixture(
    InputMessage,
    input_message
  ) do |input_message|

    input_message.assert_attributes_assigned

    # input_message.assert_metadata_attributes_assigned
  end
end
