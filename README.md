# aws_lambda_runtime

An AWS Lambda runtime for crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     aws_lambda_runtime:
       github: lagr/aws_lambda_runtime
   ```

2. Run `shards install`

## Usage

```crystal
require "aws_lambda_runtime"

AwsLambdaRuntime.run do |event, invocation|
  # do your thing
  puts event

  # return something that responds to to_json
  { "serialize-this": "my friend" }
end

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
