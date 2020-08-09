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

      def assert_attributes_assigned(attribute_names=nil)
        attribute_names ||= Messaging::Message::Metadata.all_attribute_names

        fixture(
          Schema::Fixtures::Assignment,
          metadata,
          attribute_names,
          print_title_context: false,
          attributes_context_name: "Attributes Assigned"
        )
      end

      def assert_source_attributes_assigned
        attribute_names = Messaging::Message::Metadata.source_attribute_names
        assert_attributes_assigned(attribute_names)
      end

      def assert_workflow_attributes_assigned
        attribute_names = Messaging::Message::Metadata.workflow_attribute_names
        assert_attributes_assigned(attribute_names)
      end
    end
  end
end
