# Messaging Fixtures

[TestBench](http://test-bench.software/) fixtures for the [Messaging](https://github.com/eventide-project/messaging) library

The Messaging Fixtures library provides a [TestBench test fixture](http://test-bench.software/user-guide/fixtures.html) for testing objects that are implementations of Eventide's [Messaging::Handle](http://docs.eventide-project.org/user-guide/handlers.html), [Messaging::Write](http://docs.eventide-project.org/user-guide/writing/message-writer.html), and [Messaging::Message](http://docs.eventide-project.org/user-guide/messages-and-message-data/messages.html). The test abstractions simplify and generalizes tests, reducing the test implementation effort and increasing test implementation clarity.

## Fixture

A fixture is a pre-defined, reusable test abstraction. The objects under test are specified at runtime so that the same standardized test implementation can be used against multiple objects.

A fixture is just a plain old Ruby object that includes the TestBench API. A fixture has access to the same API that any TestBench test would. By including the `TestBench::Fixture` module into a Ruby object, the object acquires all of the methods available to a test script, including context, test, assert, refute, assert_raises, refute_raises, and comment.

## Handler Fixture

The `Messaging::Fixtures::Handler` fixture tests the handling of a message. It has affordances to verify the attributes of the input message and its metadata, as well as the output message written as a result of handling the message, and the arguments sent to the writer. The handler fixture also allows a handler's entity store to be controlled, including the entity and entity version returned from the store, and it allows for control of the handler's clock and UUID generator.

``` ruby
class SomeHandler
  include Messaging::Handle

  dependency :clock, Clock::UTC
  dependency :store, SomeStore
  dependency :write, Messaging::Write

  handle SomeMessage do |some_message|
    something_id = some_message.something_id

    something, version = store.fetch(something_id, include: :version)

    if something.limit?(some_message.amount)
      logger.info(tag: :ignored) { "Message ignored: limit reached (Quantity: #{something.quantity}, Amount: #{some_message.amount}, Limit: #{Something.LIMIT})" }
      return
    end

    attributes = [
      :something_id,
      { :amount => :quantity },
      :time,
    ]

    time = clock.iso8601

    some_event = SomeEvent.follow(some_message, copy: attributes)

    some_event.processed_time = time

    some_event.metadata.correlation_stream_name = 'someCorrelationStream'
    some_event.metadata.reply_stream_name = 'someReplyStream'

    stream_name = stream_name(something_id, category: 'something')

    write.(some_event, stream_name, expected_version: version)
  end
end

context "Handle SomeMessage" do
  effective_time = Clock::UTC.now
  processed_time = effective_time + 1

  something_id = SecureRandom.uuid

  message = SomeMessage.new
  message.something_id = something_id
  message.amount = 1
  message.time = Clock.iso8601(effective_time)

  message.metadata.stream_name = "something:command-#{something_id}"
  message.metadata.position = 11
  message.metadata.global_position = 111

  something = Something.new
  something.id = something_id
  something.total = 98

  entity_version = 1111

  event_class = SomeEvent
  output_stream_name = "something-#{something_id}"

  handler = SomeHandler.new

  fixture(
    Handler,
    handler,
    message,
    something,
    entity_version,
    clock_time: processed_time
  ) do |handler|

    handler.assert_input_message do |message|
      message.assert_all_attributes_assigned

      message.assert_metadata do |metadata|
        metadata.assert_source_attributes_assigned
      end
    end

    event = handler.assert_write(event_class) do |write|
      write.assert_stream_name(output_stream_name)
      write.assert_expected_version(entity_version)
    end

    handler.assert_written_message(event) do |written_message|
      written_message.assert_follows

      written_message.assert_attributes_copied([
        :something_id,
        { :amount => :quantity },
        :time,
      ])

      written_message.assert_attribute_value(:processed_time, Clock.iso8601(processed_time))

      written_message.assert_all_attributes_assigned

      written_message.assert_metadata do |metadata|
        metadata.assert_correlation_stream_name('someCorrelationStream')
        metadata.assert_reply_stream_name('someReplyStream')
      end
    end

    handler.refute_write(SomeOtherEvent)
  end
end
```

_Note: This example is abridged for brevity. An unabridged version is included with the messaging fixtures: [https://github.com/eventide-project/messaging-fixtures/blob/master/demo.rb](https://github.com/eventide-project/messaging-fixtures/blob/master/demo.rb)_

## Running the Fixture

Running the test is no different than [running any TestBench test](http://test-bench.software/user-guide/running-tests.html).

For example, given a test file named `handler.rb` that uses the handler fixture, in a directory named `test`, the test is executed by passing the file name to the `ruby` executable.

``` bash
ruby test/handler.rb
```

The test script and the fixture work together as if they are part of the same test context, preserving output nesting between the test script file and the test fixture.

## Handler Fixture Output

``` text
Handle SomeMessage
  Handler: SomeHandler
    Input Message: SomeMessage
      Attributes Assigned
        something_id
        amount
        time
      Metadata
        Source Attributes Assigned
          stream_name
          position
          global_position
    Write: SomeEvent
      Written
      Stream name
      Expected version
    Written Message: SomeEvent
      Follows
      Attributes Copied: SomeMessage => SomeEvent
        something_id
        amount => quantity
        time
      Attribute Value
        processed_time
      Attributes Assigned
        something_id
        quantity
        time
        processed_time
      Metadata
        correlation_stream_name
        reply_stream_name
```

The output below the "Handle SomeMessage" line is from the handler fixture.

## Detailed Output

In the event of any error or failed assertion, the test output will include additional detailed output that can be useful in understanding the context of the failure and the state of the fixture itself and the objects that it's testing.

The detailed output can also be printed by setting the `TEST_BENCH_DETAIL` environment variable to `on`.

``` bash
TEST_BENCH_DETAIL=on ruby test/handler.rb
```

``` text
Handle SomeMessage
  Handler: SomeHandler
    Handler Class: SomeHandler
    Entity Class: Something
    Entity Data: {:id=>"e84533f2-53a5-492a-a8cc-ead48d3d780b", :total=>98}
    Clock Time: 2020-08-12 23:04:11.668825 UTC
    Input Message: SomeMessage
      Message Class: SomeMessage
      Attributes Assigned
        something_id
          Default Value: nil
          Assigned Value: "e84533f2-53a5-492a-a8cc-ead48d3d780b"
        amount
          Default Value: nil
          Assigned Value: 1
        time
          Default Value: nil
          Assigned Value: "2020-08-12T23:04:10.668Z"
      Metadata
        Source Attributes Assigned
          stream_name
            Default Value: nil
            Assigned Value: "something:command-e84533f2-53a5-492a-a8cc-ead48d3d780b"
          position
            Default Value: nil
            Assigned Value: 11
          global_position
            Default Value: nil
            Assigned Value: 111
    Write: SomeEvent
      Message Class: SomeEvent
      Written
        Remaining message tests are skipped
      Stream name
        Stream Name: something-e84533f2-53a5-492a-a8cc-ead48d3d780b
        Written Stream Name: something-e84533f2-53a5-492a-a8cc-ead48d3d780b
      Expected version
        Expected Version: 1111
        Written Expected Version: 1111
    Written Message: SomeEvent
      Message Class: SomeEvent
      Source Message Class: SomeMessage
      Follows
        Stream Name: "something:command-e84533f2-53a5-492a-a8cc-ead48d3d780b"
        Causation Stream Name: "something:command-e84533f2-53a5-492a-a8cc-ead48d3d780b"
        Position: 11
        Causation Position: 11
        Global Position: 111
        Causation Global Position: 111
        Source Correlation Stream Name: nil
        Correlation Stream Name: "someCorrelationStream"
        Source Reply Stream Name: nil
        Reply Stream Name: "someReplyStream"
      Attributes Copied: SomeMessage => SomeEvent
        something_id
          SomeMessage Value: "e84533f2-53a5-492a-a8cc-ead48d3d780b"
          SomeEvent Value: "e84533f2-53a5-492a-a8cc-ead48d3d780b"
        amount => quantity
          SomeMessage Value: 1
          SomeEvent Value: 1
        time
          SomeMessage Value: "2020-08-12T23:04:10.668Z"
          SomeEvent Value: "2020-08-12T23:04:10.668Z"
      Attribute Value
        processed_time
          Attribute Value: "2020-08-12T23:04:11.668Z"
          Compare Value: "2020-08-12T23:04:11.668Z"
      Attributes Assigned
        something_id
          Default Value: nil
          Assigned Value: "e84533f2-53a5-492a-a8cc-ead48d3d780b"
        quantity
          Default Value: nil
          Assigned Value: 1
        time
          Default Value: nil
          Assigned Value: "2020-08-12T23:04:10.668Z"
        processed_time
          Default Value: nil
          Assigned Value: "2020-08-12T23:04:11.668Z"
      Metadata
        correlation_stream_name
          Metadata Value: someCorrelationStream
          Compare Value: someCorrelationStream
        reply_stream_name
          Metadata Value: someReplyStream
          Compare Value: someReplyStream
```

## Actuating the Fixture

The fixture is executed using TestBench's `fixture` method.

``` ruby
fixture(Messaging::Fixtures::Handler, handler, input_message, entity=nil, entity_version=nil, clock_time: nil, identifier_uuid: nil, &test_block)
```

The first argument sent to the `fixture` method is always the `Messaging::Fixtures::Handler` class. Subsequent arguments are the specific construction parameters of the handler fixture.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| handler | Handler instance that will receive the input message and process it | Messaging::Handler |
| input_message | Input message that will be sent to the handler in order to be processed | Messaging::Message |
| entity | Optional entity object that the handler will retrieve from its entity store | (any) |
| entity_version | Optional entity version that can be retrieved along with the entity from the handler's entity store | Integer |
| clock_time | Optional time object used to fix the handler's clock to a specific time | Time |
| identifier_uuid | Optional UUID string object used to fix the handler's identifier generator to a specific UUID | String |
| test_block | Block used for invoking other assertions that are part of the handler fixture's API | Proc |

**Block Parameter**

The `handler_fixture` argument is passed to the `test_block` if the block is given.

| Name | Description | Type |
| --- | --- | --- |
| handler_fixture | Instance of the handler fixture that is being actuated | Messaging::Fixtures::Handler |

**Block Parameter Methods**

The following methods are available from the `handler_fixture` block parameter, and on an instance of `Messaging::Fixtures::Handler`:

- `assert_input_message`
- `assert_write`
- `assert_written_message`
- `refute_write`

## Test Input Message Prerequisites

``` ruby
assert_input_message(&test_block)
```

The `assert_input_message` method uses an instance of the [Messaging::Fixtures::Message](http://docs.eventide-project.org/user-guide/test-fixtures/message-fixture.html) fixture to perform the input message tests.

The message's metadata can also be tested. The metadata tests are executed by an instance of [Messaging::Fixtures::Metadata](http://docs.eventide-project.org/user-guide/test-fixtures/message-metadata-fixture.html) fixture.

**Example**

``` ruby
handler_fixture.assert_input_message do |message_fixture|
  message_fixture.assert_all_attributes_assigned

  message_fixture.assert_metadata do |metadata_fixture|
    metadata_fixture.assert_source_attributes_assigned
  end
end
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| test_block | Block used for invoking other assertions that are part of the message fixture's API | Proc |

**Block Parameter**

The `message_fixture` argument is passed to the `test_block` if the block is given.

| Name | Description | Type |
| --- | --- | --- |
| message_fixture | Instance of the the messaging fixture that is used to verify the input message | Messaging::Fixtures::Message |

**Block Parameter Methods**

- `assert_attribute_value`
- `assert_attributes_assigned`
- `assert_metadata`

## Test the Handler's Writing of an Output Message

``` ruby
assert_write(message_class, &test_block)
```

The `assert_write` method uses an instance of the [Messaging::Fixtures::Writer](http://docs.eventide-project.org/user-guide/test-fixtures/writer-fixture.html) fixture to perform the write tests.

The `asert_write` method returns an instance of the message that was written so that the written message can be further tested using the handler fixture's `assert_output_message` method.

If no written message matches the class specified by the `message_class` parameter, then the `test_block` block is not executed and the `assert_write` test fails.

**Example**

``` ruby
output_message = handler_fixture.assert_write(output_message_class) do |write_fixture|
  write_fixture.assert_stream_name(output_stream_name)
  write_fixture.assert_expected_version(entity_version)
end
```

**Returns**

The message that was written and whose class matches the `assert_write` method's `message_class` argument.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| message_class | Class of the output message that is expected to have been written | Messaging::Message |
| test_block | Block used for invoking other assertions that are part of the writer fixture's API | Proc |

**Block Parameter**

The `writer_fixture` argument is passed to the `test_block` if the block is given.

| Name | Description | Type |
| --- | --- | --- |
| writer_fixture | Instance of the the writer fixture that is used to verify the actuation of the handler's writer | Messaging::Fixtures::Write |

**Methods**

The following methods are available from the `writer_fixture` block parameter, and on an instance of `Messaging::Fixtures::Writer`:

- `assert_stream_name`
- `assert_expected_version`

## Test the Output Message Sent to the Handler's Writer

``` ruby
assert_written_message(written_message, &test_block)
```

The `assert_written_message` method uses an instance of the [Messaging::Fixtures::Message](http://docs.eventide-project.org/user-guide/test-fixtures/message-fixture.html) fixture to perform the written message tests.

The message's metadata can also be tested. The metadata tests are executed by an instance of [Messaging::Fixtures::Metadata](http://docs.eventide-project.org/user-guide/test-fixtures/message-metadata-fixture.html) fixture.

**Example**

``` ruby
handler_fixture.assert_written_message(output_message) do |written_message_fixture|
  written_message_fixture.assert_follows

  written_message_fixture.assert_attributes_copied([
    :something_id,
    { :amount => :quantity },
    :time,
  ])

  written_message_fixture.assert_attribute_value(:processed_time, Clock.iso8601(processed_time))

  written_message_fixture.assert_all_attributes_assigned

  written_message_fixture.assert_metadata do |metadata_fixture|
    metadata_fixture.assert_correlation_stream_name('someCorrelationStream')
    metadata_fixture.assert_reply_stream_name('someReplyStream')
  end
end
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| written_message | Message instance that was sent to the handler's writer | `Messaging::Message` |
| test_block | Block used for invoking other assertions that are part of the message fixture's API | Proc |

**Block Parameter**

The `message_fixture` argument is passed to the `test_block` if the block is given.

| Name | Description | Type |
| --- | --- | --- |
| message_fixture | Instance of the the messaging fixture that is used to verify the input message | Messaging::Fixtures::Message |

**Block Parameter Methods**

- `assert_attributes_copied`
- `assert_attribute_value`
- `assert_follows`
- `assert_attributes_assigned`
- `assert_metadata`

## Test That the Handler Has Not Written a Message

``` ruby
refute_write(message_class=nil)
```

**Example**

``` ruby
handler.refute_write(SomeOtherEvent)
# or
handler.refute_write
```

If no `message_class` argument is provided to the `refute_write` method, it ensures that no message was written at all.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| message_class | Optional class of a message that is not expected to have been written by the handler | Messaging::Message |

## More Fixtures

While the handler fixture is the most substantial in the messaging fixtures library, there are three other fixtures in the library that the handler fixture makes use of that can also be used on their own.

- [Message Fixture](http://docs.eventide-project.org/user-guide/message-fixture.html)
- [Message Metadata Fixture](http://docs.eventide-project.org/user-guide/message-metadata-fixture.html)
- [Writer Fixture](http://docs.eventide-project.org/user-guide/writer-fixture.html)

## More Documentation

More detailed documentation on the fixtures and their APIs can be found in the test fixtures user guide on the Eventide documentation site:

[http://docs.eventide-project.org/user-guide/test-fixtures/](http://docs.eventide-project.org/user-guide/test-fixtures/)

## License

The Messaging Fixtures library is released under the [MIT License](https://github.com/eventide-project/messaging-fixtures/blob/master/MIT-License.txt).
