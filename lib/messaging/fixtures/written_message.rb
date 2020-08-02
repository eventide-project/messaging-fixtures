module Messaging
  module Fixtures
    class WrittenMessage
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      initializer :output_message, :input_message

      def self.build(output_message, input_message)
        new(output_message, input_message)
      end

      def call(&action)
        input_message_class = input_message.class
        output_message_class = output_message.class

        context "Written Message: #{output_message_class.message_type}" do
          detail "Input Message Class: #{input_message_class.name}"
          detail "Written Message Class: #{output_message_class.name}"

          if not action.nil?
            action.call(self)
          end
        end
      end

      def assert_follows
        input_message_type = input_message.class.message_type
        output_message_type = output_message.class.message_type

        test "Follows: #{input_message_type}" do
          detail "#{input_message_type} Stream Name: #{input_message.metadata.stream_name.inspect}"
          detail "#{output_message_type} Causation Stream Name: #{output_message.metadata.causation_message_stream_name.inspect}"

          detail "#{input_message_type} Position: #{input_message.metadata.position.inspect}"
          detail "#{output_message_type} Causation Position: #{output_message.metadata.causation_message_position.inspect}"

          detail "#{input_message_type} Global Position: #{input_message.metadata.global_position.inspect}"
          detail "#{output_message_type} Causation Global Position: #{output_message.metadata.causation_message_global_position.inspect}"

          detail "#{input_message_type} Reply Stream Name: #{input_message.metadata.reply_stream_name.inspect}"
          detail "#{output_message_type} Reply Stream Name: #{output_message.metadata.reply_stream_name.inspect}"

          assert(output_message.follows?(input_message))
        end
      end

      def ___assert_attributes_copied(attribute_names=nil)
        fixture(
          Schema::Fixtures::Equality,
          input_message,
          output_message,
          attribute_names,
          ignore_class: true,
          title_context_name: "Attributes Copied: #{input_message.class.message_type} => #{output_message.class.message_type}"
        )
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
    end
  end
end
