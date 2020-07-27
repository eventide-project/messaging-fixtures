module Messaging
  module Fixtures
    module Controls
      module Event
        def self.example
          output = Output.new

          output.example_id = example_id
          output.amount = amount
          output.time = time
          output.processed_time = processed_time
          output.sequence = sequence

          output.metadata = metadata

          output
        end

        def self.example_id
          Entity.id
        end

        def self.amount
          1
        end

        def self.time
          Time::Effective.example
        end

        def self.processed_time
          Time::Processed.example
        end

        def self.sequence
          Message::Metadata.global_position + 1
        end

        def self.metadata
          Metadata.example
        end

        module Metadata
          def self.example
            metadata = Messaging::Message::Metadata.new

            metadata.causation_message_stream_name = causation_message_stream_name
            metadata.causation_message_position = causation_message_position
            metadata.causation_message_global_position = causation_message_global_position

            metadata
          end

          def self.causation_message_stream_name
            Message::Metadata.stream_name
          end

          def self.causation_message_position
            Message::Metadata.position
          end

          def self.causation_message_global_position
            Message::Metadata.global_position
          end
        end

        class Output
          include Messaging::Message

          attribute :example_id, String
          attribute :amount, Integer
          attribute :time, String
          attribute :processed_time, String
          attribute :sequence, Integer
        end

        class AlternateOutput
          include Messaging::Message

          attribute :example_id, String
          attribute :amount, Integer
          attribute :time, String
          attribute :processed_time, String
          attribute :sequence, Integer
        end
      end
    end
  end
end
