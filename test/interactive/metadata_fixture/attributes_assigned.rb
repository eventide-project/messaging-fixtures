require_relative '../interactive_init'

context "Metadata Fixture" do
  context "Assert Attributes Assigned" do
    metadata = Controls::Metadata.example

    fixture(
      Metadata,
      metadata
    ) do |metadata|

      metadata.assert_attributes_assigned

    end
  end
end
