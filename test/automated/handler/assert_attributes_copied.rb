require_relative '../../automated_init'

context "Handler" do
  context "Assert Attributes Copied" do
    handler = Controls::Handler.example
    message = Controls::Message.example

    output_message_class = Controls::Event::Output

    fixture = Handler.build(handler, message)

    # fixture.()

    # fixture.assert_written(output_message_class)

    # passed = fixture.test_session.test_passed?('Written')

    # test "Passed" do
    #   assert(passed)
    # end
  end
end
__END__
          copied_attribute_names = [
            :example_id,
            { :quantity => :amount },
            :time,
          ]

          context "Attributes" do
            fixture(
              Schema::Fixtures::Equality,
              input,
              output,
              copied_attribute_names,
              ignore_class: true,
              print_title_context: false,
              attributes_context_name: 'Copied'
            )
