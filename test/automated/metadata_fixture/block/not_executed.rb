require_relative '../../automated_init'

context "Metadata Fixture" do
  context "Block" do
    context "Metadata Is Nil" do
      metadata = nil

      effect = nil
      fixture = Metadata.build(metadata) do
        effect = :_
      end

      fixture.()

      test "Block is not executed" do
        assert(effect.nil?)
      end

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

      context "Skipped Tests Detail Notice" do
        printed = metadata_context.detail?('Remaining message tests are skipped')

        test "Printed" do
          assert(printed)
        end
      end
    end
  end
end
