require_relative 'interactive_init'

context "Write Fixture" do
  input_message = Controls::Message.example

  output_message_class = Controls::Event::Output

  attribute_names = [
    :example_id,
    { :quantity => :amount },
    :time,
  ]

  output_message = output_message_class.follow(input_message, copy: attribute_names)

  output_message.processed_time = Controls::Event.processed_time
  output_message.sequence = Controls::Event.sequence

  fixture(
    WrittenMessage,
    output_message,
    input_message
  ) do |written_message|

    written_message.assert_attributes_copied(attribute_names)

    written_message.assert_attributes_assigned

    written_message.assert_follows
  end
end
