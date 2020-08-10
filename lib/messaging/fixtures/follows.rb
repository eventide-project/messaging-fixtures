module Messaging
  module Fixtures
    class Follows
      include TestBench::Fixture
      include Initializer

      initializer :metadata, :source_metadata

      def self.build(metadata, source_metadata=nil)
        new(metadata, source_metadata)
      end

      def call
        context do
          if metadata.nil?
            test "Metadata not nil" do
              detail "Metadata: nil"
              refute(metadata.nil?)
            end
            return
          end

          if source_metadata.nil?
            test "Source metadata not nil" do
              detail "Source Metadata: nil"
              refute(source_metadata.nil?)
            end
            return
          end

          call!
        end
      end

      def call!
        test "Follows" do
          detail "Stream Name: #{source_metadata.stream_name.inspect}"
          detail "Causation Stream Name: #{metadata.causation_message_stream_name.inspect}"

          detail "Position: #{source_metadata.position.inspect}"
          detail "Causation Position: #{metadata.causation_message_position.inspect}"

          detail "Global Position: #{source_metadata.global_position.inspect}"
          detail "Causation Global Position: #{metadata.causation_message_global_position.inspect}"

          detail "Source Correlation Stream Name: #{source_metadata.correlation_stream_name.inspect}"
          detail "Correlation Stream Name: #{metadata.correlation_stream_name.inspect}"

          detail "Source Reply Stream Name: #{source_metadata.reply_stream_name.inspect}"
          detail "Reply Stream Name: #{metadata.reply_stream_name.inspect}"

          assert(metadata.follows?(source_metadata))
        end
      end
    end
  end
end
