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
          detail "Entity Data: #{entity.attributes}"

          handler.(input_message)

          if not action.nil?
            action.call(self)
          end
        end
      end

      def assert_write(message_class, &action)
        fixture = fixture(Write, handler.write, message_class, &action)

        output_message = fixture.message

        TestBench::Fixture.build(WrittenMessage, output_message, input_message, session: test_session)
      end

      def refute_write(message_class)
        write_telemetry_data = Write.get_data(handler.write, message_class)

        not_written = write_telemetry_data.nil?

        context "No Write: #{message_class.message_type}" do
          detail "Message Class: #{message_class.inspect}"
          test "Not written" do
            assert(not_written)
          end
        end
      end

      def assert_input_message(attributes=nil, &action)
        fixture = fixture(InputMessage, input_message, &action)
      end
    end
  end
end
