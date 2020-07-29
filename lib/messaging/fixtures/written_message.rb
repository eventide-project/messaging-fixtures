module Messaging
  module Fixtures
    class WrittenMessage
      include TestBench::Fixture
      include Initializer

      initializer :writer, :message

      def self.build(writer, message)
        new(writer, message)
      end

      def call
      end

      def assert_stream_name(stream_name)
        written_to_stream = writer.written?(message) do |written_stream_name|
          written_stream_name == stream_name
        end

        test "Written stream name" do
          detail "Stream Name: #{stream_name}"
          assert(written_to_stream)
        end
      end
    end
  end
end
