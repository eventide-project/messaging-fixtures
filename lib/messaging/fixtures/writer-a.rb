module Messaging
  module Fixtures
    class Writer
      include TestBench::Fixture
      include Initializer

      initializer :writer

      def self.build(writer)
        new(writer)
      end

      def call
      end

      def assert_written(message_class, &action)
        context "Written Message: #{message_class.message_type}" do
          detail "Written Message Class: #{message_class}"

          message = writer.one_message do |recorded_message|
            recorded_message.instance_of?(message_class)
          end

          test "Written" do
            refute(message.nil?)
          end

          if not action.nil?
            action.call(self)
          end
        end
      end
    end
  end
end
