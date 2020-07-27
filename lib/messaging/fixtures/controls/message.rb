module Messaging
  module Fixtures
    module Controls
      module Message
        class Input
          include Messaging::Message

          attribute :example_id, String
          attribute :quantity, Integer
          attribute :time, String
        end

        def self.example
          input = Input.new

          input.example_id = example_id
          input.quantity = quantity
          input.time = time

          input.metadata = metadata

          input
        end

        def self.example_id
          Entity.id
        end

        def self.quantity
          1
        end

        def self.time
          Time::Effective.example
        end

        def self.metadata
          Metadata.example
        end

        module Metadata
          def self.example
            metadata = Messaging::Message::Metadata.new

            metadata.stream_name = stream_name
            metadata.position = position
            metadata.global_position = global_position

            metadata
          end

          def self.stream_name
            "example:command-#{Entity.id}"
          end

          def self.position
            1
          end

          def self.global_position
            111
          end
        end
      end
    end
  end
end
