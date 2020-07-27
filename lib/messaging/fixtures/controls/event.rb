module Messaging
  module Fixtures
    module Controls
      module Event
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

        def self.sequence
          Message::Metadata.global_position + 1
        end
      end
    end
  end
end
