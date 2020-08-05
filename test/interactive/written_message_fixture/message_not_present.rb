require_relative '../interactive_init'

context "Written Message Fixture" do
  context "Message Not Present" do
    input_message = Controls::Message.example
    written_message = nil

    context "Block Given" do
      comment "Remaining tests skipped detail is printed"

      fixture(
        WrittenMessage,
        written_message,
        input_message
      ) do |written_message|
      end
    end

    context "No Block Given" do
      comment "Tests skipped detail is not printed"

      fixture(
        WrittenMessage,
        written_message,
        input_message
      )
    end
  end
end
