module Messaging
  module Fixtures
    class WrittenMessage
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      initializer :output_message, :input_message, :action

      def self.build(output_message, input_message, &action)
        new(output_message, input_message, action)
      end

      def call
        message_class = output_message.class

        context "Written Message: #{message_class.message_type}" do
          detail "Message Class: #{message_class.name}"

          if not action.nil?
            action.call(self)
          end
        end

        message
      end

      def assert_attributes_copied(attribute_names=nil)
        fixture(
          Schema::Fixtures::Equality,
          input_message,
          output_message,
          attribute_names,
          ignore_class: true,
          print_title_context: false,
          attributes_context_name: "Attributes Copied: #{input_message.class.message_type} => #{output_message.class.message_type}"
        )
      end

      def assert_attributes_assigned(attribute_names=nil)
        fixture(
          Schema::Fixtures::Assignment,
          output_message,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Attributes Assigned: #{output_message.class.message_type}"
        )
      end

      def assert_follows
        test "Follows: #{input_message.class.message_type}, #{output_message.class.message_type}" do
          detail "Input Stream Name: #{input_message.metadata.stream_name.inspect}"
          detail "Output Causation Stream Name: #{output_message.metadata.causation_message_stream_name.inspect}"

          detail "Input Position: #{input_message.metadata.position.inspect}"
          detail "Output Causation Position: #{output_message.metadata.causation_message_position.inspect}"

          detail "Input Global Position: #{input_message.metadata.global_position.inspect}"
          detail "Output Causation Global Position: #{output_message.metadata.causation_message_global_position.inspect}"

          detail "Input Reply Stream Name: #{input_message.metadata.reply_stream_name.inspect}"
          detail "Output Reply Stream Name: #{output_message.metadata.reply_stream_name.inspect}"

          assert(output_message.follows?(input_message))
        end
      end
    end
  end
end
