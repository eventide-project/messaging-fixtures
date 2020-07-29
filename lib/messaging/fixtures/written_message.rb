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
        captured_stream_name = nil
        written_to_stream = writer.written?(message) do |written_stream_name|
          if written_stream_name == stream_name
            captured_stream_name = written_stream_name
            true
          end
        end

        test "Written stream name" do
          detail "Stream Name: #{stream_name}"
          detail "Written Stream Name: #{captured_stream_name}"

          assert(written_to_stream)
        end
      end

      def assert_expected_version(expected_version)
        captured_expected_version = nil
        written_with_expected_version = writer.written?(message) do |_, written_expected_version|
          if written_expected_version == expected_version
            captured_expected_version = written_expected_version
            true
          end
        end

        test "Expected version" do
          detail "Expected Version: #{expected_version}"
          detail "Written Expected Version: #{captured_expected_version}"

          assert(written_with_expected_version)
        end
      end
    end
  end
end
