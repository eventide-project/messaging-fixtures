module Messaging
  module Fixtures
    class Metadata
      include TestBench::Fixture
      include Initializer

      initializer :metadata, :source_metadata, :action

      def self.build(metadata, source_metadata=nil, &action)
        new(metadata, source_metadata, action)
      end

      def call
        context "Metadata" do
          if metadata.nil?
            test "Not nil" do
              detail "Metadata: nil"

              if not action.nil?
                detail "Remaining message tests are skipped"
              end

              refute(metadata.nil?)
            end
            return
          end

          if not action.nil?
            action.call(self)
          end
        end
      end

      def assert_attributes_assigned(attribute_names=nil, context_title_qualifier: nil)
        attribute_names ||= Messaging::Message::Metadata.all_attribute_names

        attributes_context_title = "#{context_title_qualifier} Attributes Assigned".lstrip

        fixture(
          Schema::Fixtures::Assignment,
          metadata,
          attribute_names,
          print_title_context: false,
          attributes_context_name: attributes_context_title
        )
      end

      def assert_source_attributes_assigned
        attribute_names = Messaging::Message::Metadata.source_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: 'Source')
      end

      def assert_workflow_attributes_assigned
        attribute_names = Messaging::Message::Metadata.workflow_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: 'Workflow')
      end

      def assert_causation_attributes_assigned
        attribute_names = Messaging::Message::Metadata.causation_attribute_names
        assert_attributes_assigned(attribute_names, context_title_qualifier: 'Causation')
      end

      def assert_correlation_stream_name(correlation_stream_name)
        metadata_value = metadata.correlation_stream_name

        test "correlation_stream_name" do
          detail "Metadata Value: #{metadata_value}"
          detail "Compare Value: #{correlation_stream_name}"
          assert(metadata_value == correlation_stream_name)
        end
      end

      def assert_reply_stream_name(reply_stream_name)
        metadata_value = metadata.reply_stream_name

        test "reply_stream_name" do
          detail "Metadata Value: #{metadata_value}"
          detail "Compare Value: #{reply_stream_name}"
          assert(metadata_value == reply_stream_name)
        end
      end

      def assert_follows
        if source_metadata.nil?
          test "Source metadata not nil" do
            detail "Source Metadata: nil"
            refute(source_metadata.nil?)
          end
          return
        end

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
