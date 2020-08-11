require_relative '../../automated_init'

context "Write Fixture" do
  context "Block" do
    context "Message Is Not Written" do
      writer = Messaging::Write::Substitute.build
      message = Controls::Event.example
      stream_name = "example-#{message.example_id}"

      effect = nil
      fixture = fixture = Write.build(writer, message.class) do
        effect = :_
      end

      fixture.()

      test "Block is not executed" do
        assert(effect.nil?)
      end

      context_text = 'Write'
      context "Context: \"#{context_text}\"" do
        printed = fixture.test_session.context?(context_text)

        test "Printed" do
          assert(printed)
        end
      end

      write_context = fixture.test_session[context_text]
      context "Written" do
        failed = write_context.test_failed?('Written')

        test "Failed" do
          assert(failed)
        end
      end

      context "Skipped Tests Detail Notice" do
        printed = write_context.detail?('Remaining message tests are skipped')

        test "Printed" do
          assert(printed)
        end
      end
    end
  end
end
