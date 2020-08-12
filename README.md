# Messaging Fixtures

[TestBench](http://test-bench.software/) fixtures for the [Messaging](https://github.com/eventide-project/messaging) library

The Messaging Fixtures library provides a [TestBench test fixture](http://test-bench.software/user-guide/fixtures.html) for testing objects that are implementations of Eventide's [Messaging::Handle](http://docs.eventide-project.org/user-guide/handlers.html), [Messaging::Write](http://docs.eventide-project.org/user-guide/writing/message-writer.html). and [Messaging::Message](http://docs.eventide-project.org/user-guide/messages-and-message-data/messages.html). The test abstractions simplify and generalizes tests, reducing the test implementation effort and increasing test implementation clarity.

## Fixture

A fixture is a pre-defined, reusable test abstraction. The objects under test are specified at runtime so that the same standardized test implementation can be used against multiple objects.

A fixture is just a plain old Ruby object that includes the TestBench API. A fixture has access to the same API that any TestBench test would. By including the `TestBench::Fixture` module into a Ruby object, the object acquires all of the methods available to a test script, including context, test, assert, refute, assert_raises, refute_raises, and comment.

## Handler Fixture

The `Messaging::Fixtures::Handler` fixture tests the handling of a message. It has affordances to verify the attributes of the input message and its metadata, as well as the output message written as a result of handling the message, and the arguments sent to the writer. The handler fixture also allows a handler's entity store to be controlled, including the entity and entity version returned from the store, and it allows for control of the handler's clock and UUID generator.

``` ruby
require_relative 'test/test_init'

class SomeMessage
  include Messaging::Message

  attribute :something_id, String
  attribute :amount, Integer
  attribute :time, String
end

class SomeEvent
  include Messaging::Message

  attribute :something_id, String
  attribute :quantity, Integer
  attribute :time, String
  attribute :processed_time, String
end

class Something
  include Schema::DataStructure

  LIMIT = 100

  attribute :id, String
  attribute :total, Integer, default: 0

  def accumulate(quantity)
    self.total += quantity
  end

  def limit?(quantity)
    (quantity + total) >= LIMIT
  end
end

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
      message.assert_attributes_assigned

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

      written_message.assert_attributes_assigned

      written_message.assert_metadata do |metadata|
        metadata.assert_correlation_stream_name('someCorrelationStream')
        metadata.assert_reply_stream_name('someReplyStream')
      end
    end
  end
end
```

Running the test is no different than [running any TestBench test](http://test-bench.software/user-guide/running-tests.html). In its simplest form, running the test is done by passing the test file name to the `ruby` executable.

``` bash
ruby test/handler.rb
```

The test script and the fixture work together as if they are the same test.

```
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

### Detailed Output

The fixture will print more detailed output if the `TEST_BENCH_DETAIL` environment variable is set to `on`.

``` bash
TEST_BENCH_DETAIL=on ruby test/handler.rb
```

```
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

### Projection Fixture API

Class: `EntityProjection::Fixtures::Projection`

#### Construct the Projection Fixture

The projection fixture is only ever constructed directly when [testing](http://test-bench.software/user-guide/fixtures.html#testing-fixtures) the fixture. Usually, when the fixture is used to fulfill its purpose of testing a projection, TestBench's `fixture` method is used.

``` ruby
self.build(projection, event, &action)
```

**Returns**

Instance of `EntityProjection::Fixtures::Projection`

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| projection | Projection used to apply the event to the entity | EntityProjection |
| entity | Object to project state into  | (any) |
| event | Event to project state from | Messaging::Message |
| action | Supplemental proc evaluated in the context of the fixture. Used for invoking other assertions that are part of the fixture's API. | Proc |

#### Actuating the Fixture

The projection fixture is only ever actuated directly when [testing](http://test-bench.software/user-guide/fixtures.html#testing-fixtures) the fixture. Usually, when the fixture is used to fulfill its purpose of testing a projection, TestBench's `fixture` method is used.

``` ruby
call()
```

#### Testing Attribute Values

The `assert_attributes_copied` method tests that attribute values are copied from the event being applied to the entity receiving the attribute data. By default, all attributes from the event are compared to entity attributes of the same name. An optional list of attribute names can be passed. When the list of attribute names is passed, only those attributes will be compared. The list of attribute names can also contain maps of attribute names for comparing values when the entity attribute name is not the same as the event attribute name.

``` ruby
assert_attributes_copied(attribute_names=[])
```

**Parameters**

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| attribute_names | Optional list of attribute names to limit testing to | Array of Symbol or Hash | Attribute names of left-hand side object |

The `assert_attributes_copied` method is implemented using the `Schema::Fixture::Equality` fixture from the [Schema Fixture library](https://github.com/eventide-project/schema-fixtures).

#### Testing Individual Attribute Transformations

Projects may not just copy attributes from an event to an entity verbatim. A projection might transform or convert the event data that it's assigning to an entity. The `assert_transformed_and_copied` method allows an event attribute to be transformed before being compared to an entity attribute.

``` ruby
assert_time_converted_and_copied(time_attribute_name)
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| attribute_name | Name of the event attribute, or map of event attribute name to entity attribute name, to be compared | Symbol or Hash |

## License

The `entity-projection-fixtures` library is released under the [MIT License](https://github.com/eventide-project/entity-projection-fixtures/blob/master/MIT-License.txt).
