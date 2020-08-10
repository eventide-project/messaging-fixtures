require_relative '../automated_init'

context "Metadata Fixture" do
  context "No Metadata" do
    metadata = nil

    fixture = Metadata.build(metadata) {}

    fixture.()

    context_text = 'Metadata'
    context "Context: \"#{context_text}\"" do
      printed = fixture.test_session.context?(context_text)

      test "Printed" do
        assert(printed)
      end
    end

    metadata_context = fixture.test_session[context_text]
    context "Not nil" do
      failed = metadata_context.test_failed?('Not nil')

      test "Failed" do
        assert(failed)
      end
    end
  end
end
