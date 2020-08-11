module Messaging
  module Fixtures
    class Handler
      Error = Class.new(RuntimeError)

      include TestBench::Fixture
      include Initializer

      def entity_sequence
        return nil if entity.nil?
        entity.sequence
      end

      initializer :handler, :input_message, :entity, :entity_version, :clock_time, :uuid, :action

      def self.build(handler, input_message, entity=nil, entity_version=nil, clock_time: nil, uuid: nil, &action)
        instance = new(handler, input_message, entity, entity_version, clock_time, uuid, action)

        set_store_entity(handler, entity, entity_version)
        set_clock_time(handler, clock_time)
        set_identifier_uuid(handler, uuid)

        instance
      end

      def self.set_store_entity(handler, entity, entity_version)
        return if entity.nil?

        handler.store.add(entity.id, entity, entity_version)
      end

      def self.set_clock_time(handler, clock_time)
        if clock_time.nil?
          if handler.respond_to?(:clock)
            handler.clock.now = Defaults.clock_time
          end
        else
          handler.clock.now = clock_time
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

          if action.nil?
            raise Error, "Handler fixture must be executed with a block"
          end

          detail "Entity Class: #{entity.class.name}"
          detail "Entity Data: #{entity&.attributes.inspect}"

          if not clock_time.nil?
            detail "Clock clock_Time: #{clock_time.inspect}"
          end

          handler.(input_message)

          action.call(self)
        end
      end

      def assert_input_message(&action)
        context_name = "Input Message"
        if not input_message.nil?
          context_name = "#{context_name}: #{input_message.class.message_type}"
        end

        fixture(Message, input_message, title_context_name: context_name, &action)
      end

      def assert_written_message(written_message, &action)
        context_name = "Written Message"
        if not written_message.nil?
          context_name = "#{context_name}: #{written_message.class.message_type}"
        end

        fixture(Message, written_message, input_message, title_context_name: context_name, &action)
      end

      def assert_write(message_class, &action)
        fixture = fixture(Write, handler.write, message_class, &action)
        fixture.message
      end

      def refute_write(message_class=nil)
        writer = handler.write

        context_name = "No Write"
        if not message_class.nil?
          write_telemetry_data = Write.get_data(writer, message_class)
          written = !write_telemetry_data.nil?
          context_name = "#{context_name}: #{message_class.message_type}"
        else
          written = writer.written?
        end

        context context_name do
          detail "Message Class: #{message_class.inspect}"
          test "Not written" do
            refute(written)
          end
        end
      end
    end
  end
end
