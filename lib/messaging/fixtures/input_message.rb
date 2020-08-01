module Messaging
  module Fixtures
    class InputMessage
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      initializer :input_message, :action

      def self.build(input_message, &action)
        new(input_message, action)
      end

      def call
        input_message_class = input_message.class

        context "Input Message: #{input_message_class.message_type}" do
          detail "Input Message Class: #{input_message_class.name}"

          if not action.nil?
            action.call(self)
          end
        end
      end

      def assert_attributes_assigned(attribute_names=nil)
        fixture(
          Schema::Fixtures::Assignment,
          input_message,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Attributes Assigned"
        )
      end

      def assert_metadata_attributes_assigned(attribute_names=nil)
        attribute_names = [:stream_name, :position, :global_position]

        metadata = input_message.metadata

        fixture(
          Schema::Fixtures::Assignment,
          metadata,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Metadata Attributes Assigned"
        )
      end
    end
  end
end
