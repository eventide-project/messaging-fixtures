require_relative '../../interactive_init'

context "Metadata Fixture" do
  context "Follows" do
    context "No Source Metadata" do
      source_metadata = nil
      metadata = Controls::Metadata.example

      fixture(
        Metadata,
        metadata,
        source_metadata
      ) do |f|

        f.assert_follows

      end
    end
  end
end
