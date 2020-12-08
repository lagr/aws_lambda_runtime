# aws_lambda_runtime

An AWS Lambda runtime for crystal.

---

**While this is a working implementation, it is not tested yet and the API is likely subject to change.** Feel free to give it a try, nonetheless!

---

## Installation

1. Add the dependency to your `shard.yml`:

    ```yaml
    dependencies:
      aws_lambda_runtime:
        github: lagr/aws_lambda_runtime
    ```

2. Run `shards install`

## Usage

The basic usage which should be suitable for most use cases is as follows:

```crystal
require "aws_lambda_runtime"

AwsLambdaRuntime.run do |event, invocation|
  # do your thing

  puts "event is a #{event.class.name}."
  # => event is a JSON::Any.

  # return something that responds to to_json
  { "serialize-this": "my friend" }
end
```

This will provide `event` as `JSON::Any` and `invocation` as [`AwsLambdaRuntime::Invocation`](../master/src/aws_lambda_runtime/invocation.cr) to the block.

## Advanced Usage

Passing a Proc, e.g. one derived from a method, permits to bypass the parsing of the event as `JSON::Any`:

```crystal
def handler(event, invocation)
  # do your thing

  puts "event is a #{event.class.name}."
  # => event is a String.

  # return something that responds to to_json
  { "serialize-this": "my friend" }
end

AwsLambdaRuntime.run(->handler(String, AwsLambdaRuntime::Invocation))
```

Working on the raw `String` can be handy to define custom mappings for the expected event data or to defer parsing to a later point in time:

```crystal
class SQSMessage
  include JSON::Serializable

  @[JSON::Field(key: "messageId")]
  property message_id : String

  property attributes : JSON::Any
end

class SQSEvent
  include JSON::Serializable

  @[JSON::Field(key: "Records")]
  property messages : Array(SQSMessage)
end

def handler(event, invocation)
  puts "event is a #{event.class.name}."
  sqs_event = SQSEvent.from_json(event)

  { "first-message-attributes": sqs_event.messages.first.attributes }
end

AwsLambdaRuntime.run(->handler(String, AwsLambdaRuntime::Invocation))
```

## Development

TODO: :-)

## Notable Mentions

This shard is inspired by [crambda](https://github.com/lambci/crambda).

## Contributing

1. Fork it (<https://github.com/lagr/aws_lambda_runtime/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lars Greiving](https://github.com/lagr) - creator and maintainer
