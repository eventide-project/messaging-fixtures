module Messaging
  module Fixtures
    class Handler
      include TestBench::Fixture
      include Initializer

      def entity_sequence
        return nil if entity.nil?
        entity.sequence
      end

      initializer :handler, :input_message, :entity, :entity_version, :time, :uuid, :action

      def self.build(handler, input_message, entity=nil, entity_version=nil, time: nil, uuid: nil, &action)
        instance = new(handler, input_message, entity, entity_version, time, uuid, action)

        set_store_entity(handler, entity, entity_version)
        set_clock_time(handler, time)
        set_identifier_uuid(handler, uuid)

        instance
      end

      def self.set_store_entity(handler, entity, entity_version)
        return if entity.nil?

        handler.store.add(entity.id, entity, entity_version)
      end

      def self.set_clock_time(handler, time)
        if time.nil?
          if handler.respond_to?(:clock)
            handler.clock.now = Defaults.time
          end
        else
          handler.clock.now = time
        end
      end

      def self.set_identifier_uuid(handler, uuid)
        if uuid.nil?
          if handler.respond_to?(:identifier)
            handler.identifier.set(Defaults.uuid)
          end
        else
          handler.identifier.set(uuid)
        end
      end

      def call
        context "Handler: #{handler.class.name.split('::').last}" do
          detail "Handler Class: #{handler.class.name}"

          detail "Entity Class: #{entity.class.name}"
          ## Problem: entity might not have sequence
          ## Maybe don't print this
          ## Could be something that a user puts in their own test code
          detail "Entity Sequence: #{entity_sequence.inspect}"

          handler.(input_message)

          if not action.nil?
            action.call(self)
          end
        end
      end

      def assert_written(message_class, &action)
        fixture = fixture(WrittenMessage, handler.write, message_class, &action)
        fixture.message
      end

      def assert_attributes_copied(output_message, attribute_names=nil)
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

      def assert_attributes_assigned(output_message, attribute_names=nil)
        fixture(
          Schema::Fixtures::Assignment,
          output_message,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Attributes Assigned: #{output_message.class.message_type}"
        )
      end

      def assert_follows(output_message)
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
